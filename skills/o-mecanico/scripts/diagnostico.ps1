<#
.SYNOPSIS
    Script de diagnóstico de hardware e telemetria de sistema para o plugin O Mecânico.
.DESCRIPTION
    Coleta dados em tempo real sobre CPU, GPU, RAM, Memória Virtual, Discos e processos.
.PARAMETER Json
    Retorna os dados coletados exclusivamente em formato JSON estruturado.
.PARAMETER TopProcesses
    Exibe os processos com maior consumo de recursos de CPU e memória.
#>

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$TopProcesses
)

$ErrorActionPreference = "SilentlyContinue"

# Coleta de Sistema Operacional e RAM
$os = Get-CimInstance Win32_OperatingSystem
$totalRamMb = [math]::Round($os.TotalVisibleMemorySize / 1024, 0)
$freeRamMb  = [math]::Round($os.FreePhysicalMemory / 1024, 0)
$usedRamMb  = $totalRamMb - $freeRamMb
$ramPercent = [math]::Round(($usedRamMb / $totalRamMb) * 100, 1)

$totalSwapMb = [math]::Round($os.TotalVirtualMemorySize / 1024, 0)
$freeSwapMb  = [math]::Round($os.FreeVirtualMemory / 1024, 0)
$usedSwapMb  = $totalSwapMb - $freeSwapMb
$swapPercent = [math]::Round(($usedSwapMb / $totalSwapMb) * 100, 1)

# Coleta de CPU
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$cpuLoad = $cpu.LoadPercentage
if ($null -eq $cpuLoad) {
    $cpuLoad = [math]::Round((Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 1).CounterSamples[0].CookedValue, 1)
}

# Coleta de GPU
$gpus = Get-CimInstance Win32_VideoController | ForEach-Object {
    $vramMb = if ($_.AdapterRAM -gt 0) { [math]::Round($_.AdapterRAM / 1MB, 0) } else { 0 }
    [PSCustomObject]@{
        Nome      = $_.Name
        Fabricante = $_.AdapterCompatibility
        Driver    = $_.DriverVersion
        VRAM_MB   = $vramMb
        Status    = $_.Status
    }
}

# Coleta de Discos Fixos
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 3" | ForEach-Object {
    $totalGb = [math]::Round($_.Size / 1GB, 1)
    $freeGb  = [math]::Round($_.FreeSpace / 1GB, 1)
    $usedGb  = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 1)
    $usedPct = if ($totalGb -gt 0) { [math]::Round(($usedGb / $totalGb) * 100, 1) } else { 0 }
    [PSCustomObject]@{
        Unidade     = $_.DeviceID
        Total_GB    = $totalGb
        Usado_GB    = $usedGb
        Livre_GB    = $freeGb
        PercentUsado = $usedPct
    }
}

# Coleta de Processos
$procList = @()
if ($TopProcesses -or $Json) {
    $procList = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 10 | ForEach-Object {
        [PSCustomObject]@{
            Id        = $_.Id
            Nome      = $_.ProcessName
            MemoriaMB = [math]::Round($_.WorkingSet64 / 1MB, 1)
            CPU_Seg   = [math]::Round($_.CPU, 1)
        }
    }
}

# Estrutura consolidada
$report = [PSCustomObject]@{
    Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Computador = $env:COMPUTERNAME
    CPU = [PSCustomObject]@{
        Modelo   = $cpu.Name.Trim()
        Nucleos  = $cpu.NumberOfCores
        Threads  = $cpu.NumberOfLogicalProcessors
        UsoAtual = "$cpuLoad%"
    }
    RAM = [PSCustomObject]@{
        Total_GB  = [math]::Round($totalRamMb / 1024, 2)
        Usado_GB  = [math]::Round($usedRamMb / 1024, 2)
        Livre_GB  = [math]::Round($freeRamMb / 1024, 2)
        Percentual = "$ramPercent%"
    }
    Swap = [PSCustomObject]@{
        Total_GB  = [math]::Round($totalSwapMb / 1024, 2)
        Usado_GB  = [math]::Round($usedSwapMb / 1024, 2)
        Percentual = "$swapPercent%"
    }
    GPU = $gpus
    Discos = $disks
    TopProcessos = $procList
}

if ($Json) {
    $report | ConvertTo-Json -Depth 4
    exit 0
}

# Saída Visual em Estilo Retrô Militar
Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "|   O MECANICO: RELATORIO DE TELEMETRIA E DIAGNOSTICO DE HARDWARE        |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""
Write-Host " [CPU] $($report.CPU.Modelo)" -ForegroundColor Yellow
Write-Host "       Nucleos: $($report.CPU.Nucleos) | Threads: $($report.CPU.Threads) | Carga Atual: $($report.CPU.UsoAtual)" -ForegroundColor Gray

Write-Host ""
Write-Host " [RAM] Total: $($report.RAM.Total_GB) GB | Usado: $($report.RAM.Usado_GB) GB ($($report.RAM.Percentual)) | Livre: $($report.RAM.Livre_GB) GB" -ForegroundColor Green
Write-Host " [SWAP] Virtual: $($report.Swap.Total_GB) GB | Usado: $($report.Swap.Usado_GB) GB ($($report.Swap.Percentual))" -ForegroundColor Gray

Write-Host ""
Write-Host " [GPU(s) DETECTADAS]" -ForegroundColor Yellow
foreach ($g in $gpus) {
    $vramInfo = if ($g.VRAM_MB -gt 0) { "$($g.VRAM_MB) MB VRAM" } else { "Memoria Compartilhada" }
    Write-Host "  * $($g.Nome) ($vramInfo) [Driver: $($g.Driver)]" -ForegroundColor Gray
}

Write-Host ""
Write-Host " [DISCOS DE ARMAZENAMENTO]" -ForegroundColor Yellow
foreach ($d in $disks) {
    $color = if ($d.PercentUsado -gt 85) { "Red" } else { "Green" }
    Write-Host "  * Unidade $($d.Unidade) Total: $($d.Total_GB) GB | Usado: $($d.Usado_GB) GB ($($d.PercentUsado)%) | Livre: $($d.Livre_GB) GB" -ForegroundColor $color
}

if ($TopProcesses) {
    Write-Host ""
    Write-Host " [TOP 10 PROCESSOS POR CONSUMO DE MEMORIA]" -ForegroundColor Yellow
    $procList | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor Gray
}

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "| Fim da Telemetria. Sistema pronto para intervencao ou tuning.          |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""

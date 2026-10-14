<#
.SYNOPSIS
    Script de ativacao do Modo Gamer e otimizacao cirurgica de RAM para o plugin O Mecanico.
.DESCRIPTION
    Habilita otimizacoes do Windows Game Mode, efetua trimming de working sets inativos
    da memoria RAM e eleva a prioridade de processos selecionados.
.PARAMETER GameProcess
    Nome do processo de jogo a ter prioridade de CPU elevada (ex: -GameProcess "game.exe").
.PARAMETER Json
    Retorna os dados consolidados em formato JSON.
#>

[CmdletBinding()]
param(
    [string]$GameProcess,
    [switch]$Json
)

$ErrorActionPreference = "SilentlyContinue"

# Funcao de telemetria de RAM
function Get-RamSnapshot {
    $os = Get-CimInstance Win32_OperatingSystem
    $totalMb = [math]::Round($os.TotalVisibleMemorySize / 1024, 0)
    $freeMb  = [math]::Round($os.FreePhysicalMemory / 1024, 0)
    $usedMb  = $totalMb - $freeMb
    return [PSCustomObject]@{
        TotalMB = $totalMb
        FreeMB  = $freeMb
        UsedMB  = $usedMb
        PctUsed = [math]::Round(($usedMb / $totalMb) * 100, 1)
    }
}

$ramBefore = Get-RamSnapshot

# 1. Ajuste de Game Mode no Registro do Windows
$gameBarPath = "HKCU:\Software\Microsoft\GameBar"
$gameDvrPath = "HKCU:\System\GameConfigStore"
$gameModeStatus = "Inalterado"

try {
    if (-not (Test-Path $gameBarPath)) {
        New-Item -Path $gameBarPath -Force | Out-Null
    }
    Set-ItemProperty -Path $gameBarPath -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $gameBarPath -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force

    if (Test-Path $gameDvrPath) {
        Set-ItemProperty -Path $gameDvrPath -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
    }
    $gameModeStatus = "Ativado (Prioridade para Jogos no Windows)"
} catch {
    $gameModeStatus = "Disponivel com configuracao padrao"
}

# 2. Trimming de Working Set de Memoria
$csharpCode = @"
using System;
using System.Runtime.InteropServices;
public class MemoryOptimizer {
    [DllImport("psapi.dll")]
    public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@

$typeAdded = $false
try {
    if (-not ([System.Management.Automation.PSTypeName]'MemoryOptimizer').Type) {
        Add-Type -TypeDefinition $csharpCode -ErrorAction SilentlyContinue
    }
    $typeAdded = $true
} catch {
    $typeAdded = $false
}

$trimmedProcesses = 0
$criticalList = @("system", "idle", "csrss", "lsass", "smss", "services", "wininit")

if ($typeAdded) {
    Get-Process | Where-Object {
        $_.Id -gt 4 -and
        $criticalList -notcontains $_.ProcessName.ToLower() -and
        $_.WorkingSet64 -gt 15MB
    } | ForEach-Object {
        try {
            [MemoryOptimizer]::EmptyWorkingSet($_.Handle) | Out-Null
            $trimmedProcesses++
        } catch {}
    }
}

[System.GC]::Collect()

# Pausa breve para estabilizacao de contadores
Start-Sleep -Milliseconds 600
$ramAfter = Get-RamSnapshot
$recoveredMb = [math]::Max(0, ($ramAfter.FreeMB - $ramBefore.FreeMB))

# 3. Elevacao de Prioridade de Processo Alvo
$targetElevated = "Nenhum informado"
if ($GameProcess) {
    $cleanName = [System.IO.Path]::GetFileNameWithoutExtension($GameProcess)
    $targetProcs = Get-Process -Name $cleanName -ErrorAction SilentlyContinue
    if ($targetProcs) {
        foreach ($p in $targetProcs) {
            try {
                $p.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
                $targetElevated = "$($p.ProcessName) (PID: $($p.Id)) elevada para HIGH"
            } catch {
                $targetElevated = "Permissao insuficiente para elevar $($p.ProcessName)"
            }
        }
    } else {
        $targetElevated = "Processo '$cleanName' nao encontrado em execucao"
    }
}

$result = [PSCustomObject]@{
    Timestamp          = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    GameMode           = $gameModeStatus
    ProcessosOtimizados = $trimmedProcesses
    ProcessoAlvo       = $targetElevated
    RAM_Antes          = [PSCustomObject]@{ Usado_MB = $ramBefore.UsedMB; Livre_MB = $ramBefore.FreeMB; Pct = "$($ramBefore.PctUsed)%" }
    RAM_Depois         = [PSCustomObject]@{ Usado_MB = $ramAfter.UsedMB; Livre_MB = $ramAfter.FreeMB; Pct = "$($ramAfter.PctUsed)%" }
    MemoriaRecuperadaMB = $recoveredMb
}

if ($Json) {
    $result | ConvertTo-Json -Depth 4
    exit 0
}

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "|   O MECANICO: ATIVACAO DE MODO GAMER E TUNING DE MEMORIA               |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""
Write-Host " [STATUS GAMING] $gameModeStatus" -ForegroundColor Green
Write-Host " [OTIMIZACAO] Working set de $trimmedProcesses processos em segundo plano enxugado." -ForegroundColor Yellow

if ($GameProcess) {
    Write-Host " [PROCESSO ALVO] $targetElevated" -ForegroundColor Cyan
}

Write-Host ""
Write-Host " RAM ANTES : Usada: $($ramBefore.UsedMB) MB ($($ramBefore.PctUsed)%) | Livre: $($ramBefore.FreeMB) MB" -ForegroundColor Gray
Write-Host " RAM DEPOIS: Usada: $($ramAfter.UsedMB) MB ($($ramAfter.PctUsed)%) | Livre: $($ramAfter.FreeMB) MB" -ForegroundColor Green
Write-Host ""

if ($recoveredMb -gt 0) {
    Write-Host " [RESULTADO] Memoria fisica liberada com sucesso: +$recoveredMb MB disponiveis!" -ForegroundColor Green
} else {
    Write-Host " [RESULTADO] Memoria ja estava estavel e otimizada." -ForegroundColor Gray
}

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "| Sistema pronto para jogos ou cargas computacionais intensas.           |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""

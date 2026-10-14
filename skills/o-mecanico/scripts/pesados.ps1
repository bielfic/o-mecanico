<#
.SYNOPSIS
    O Cacador de Gigabytes: Motor Generalista de Auditoria Profunda e Otimizacao Estrutural de Espaco.
.DESCRIPTION
    Funciona em qualquer PC com Windows. Realiza analise consultiva de:
    1. Filtro de Abandono Temporal em pastas pesadas (AppData, Downloads sem modificacao ha +60/90 dias).
    2. Softwares Ociosos e Redundancias via Registro (multiplos navegadores, gravadores, bloatwares OEM).
    3. Otimizacoes Estruturais do Sistema (tamanho de hiberfil.sys, pagefile.sys e ganho de desativar hibernacao).
    4. Simulacao de Ganho Consultivo (Nivel Seguro vs Nivel Otimizado com espaco projetado).
.PARAMETER DiasAbandono
    Dias de inatividade para classificar pasta ou instalador como ocioso (padrao: 60).
.PARAMETER MinFolderMB
    Tamanho minimo em MB para pastas no AppData (padrao: 300).
.PARAMETER Json
    Retorna o relatorio consolidado exclusivamente em formato JSON.
#>

[CmdletBinding()]
param(
    [int]$DiasAbandono = 60,
    [int]$MinFolderMB = 300,
    [switch]$Json
)

$ErrorActionPreference = "SilentlyContinue"

# Funcao de tamanho de pasta em MB
function Get-FolderSizeMB ($folderPath) {
    if (-not (Test-Path -Path $folderPath)) { return 0 }
    $size = (Get-ChildItem -Path $folderPath -Recurse -File -Force -ErrorAction SilentlyContinue |
        Measure-Object -Property Length -Sum).Sum
    if ($null -eq $size) { return 0 }
    return [math]::Round($size / 1MB, 1)
}

$dataLimite = (Get-Date).AddDays(-$DiasAbandono)

# 1. Analise Estrutural de Arquivos de Sistema no Disco C:
$hiberFile = Get-Item "C:\hiberfil.sys" -Force -ErrorAction SilentlyContinue
$pageFile  = Get-Item "C:\pagefile.sys" -Force -ErrorAction SilentlyContinue
$swapFile  = Get-Item "C:\swapfile.sys" -Force -ErrorAction SilentlyContinue

$hiberGb = if ($hiberFile) { [math]::Round($hiberFile.Length / 1GB, 2) } else { 0 }
$pageGb  = if ($pageFile)  { [math]::Round($pageFile.Length / 1GB, 2) } else { 0 }
$swapGb  = if ($swapFile)  { [math]::Round($swapFile.Length / 1GB, 2) } else { 0 }

# 2. Varredura com Filtro de Abandono Temporal (AppData Local e Roaming)
$appDataRoots = @("$env:LOCALAPPDATA", "$env:APPDATA")
$pastasPesadas = @()

foreach ($root in $appDataRoots) {
    if (Test-Path $root) {
        Get-ChildItem -Path $root -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
            $folder = $_
            $mb = Get-FolderSizeMB $folder.FullName
            if ($mb -ge $MinFolderMB) {
                # Verifica a data do arquivo mais recente dentro da pasta para aferir abandono
                $latestFile = Get-ChildItem -Path $folder.FullName -Recurse -File -Force -ErrorAction SilentlyContinue |
                    Sort-Object LastWriteTime -Descending | Select-Object -First 1

                $ultimoUso = if ($latestFile) { $latestFile.LastWriteTime } else { $folder.LastWriteTime }
                $diasInativo = [math]::Round(((Get-Date) - $ultimoUso).TotalDays, 0)
                $isOcioso = $ultimoUso -lt $dataLimite

                $pastasPesadas += [PSCustomObject]@{
                    Nome        = $folder.Name
                    Origem      = if ($root -like "*Local*") { "AppData\Local" } else { "AppData\Roaming" }
                    TamanhoMB   = $mb
                    TamanhoGB   = [math]::Round($mb / 1024, 2)
                    UltimoAcesso = $ultimoUso.ToString("yyyy-MM-dd")
                    DiasSemUso  = $diasInativo
                    Ocioso      = $isOcioso
                    Caminho     = $folder.FullName
                }
            }
        }
    }
}

# 3. Instaladores e Arquivos Esquecidos em Downloads
$downloadDirs = @("$env:USERPROFILE\Downloads", "$env:USERPROFILE\OneDrive\Downloads")
$exts = @("*.exe", "*.msi", "*.iso", "*.bin", "*.crdownload", "*.zip", "*.rar", "*.7z")
$instaladoresAbandonados = @()

foreach ($dir in $downloadDirs) {
    if (Test-Path $dir) {
        foreach ($e in $exts) {
            Get-ChildItem -Path $dir -Filter $e -File -Force -ErrorAction SilentlyContinue |
                Where-Object { $_.Length -ge 50MB } | ForEach-Object {
                    $dias = [math]::Round(((Get-Date) - $_.LastWriteTime).TotalDays, 0)
                    $instaladoresAbandonados += [PSCustomObject]@{
                        Arquivo    = $_.Name
                        TamanhoMB  = [math]::Round($_.Length / 1MB, 1)
                        TamanhoGB  = [math]::Round($_.Length / 1GB, 2)
                        Data       = $_.LastWriteTime.ToString("yyyy-MM-dd")
                        DiasSemUso = $dias
                        Ocioso     = ($dias -ge 30)
                        Caminho    = $_.FullName
                    }
                }
        }
    }
}

# 4. Auditoria de Softwares Instalados via Registro (Detectando Redundancias e Ociosidade)
$regPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$installedPrograms = @()
foreach ($rp in $regPaths) {
    Get-ItemProperty $rp -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -and $_.SystemComponent -ne 1 } | ForEach-Object {
        $name = $_.DisplayName
        $sizeMb = if ($_.EstimatedSize) { [math]::Round($_.EstimatedSize / 1024, 1) } else { 0 }
        $installDate = $_.InstallDate

        $installedPrograms += [PSCustomObject]@{
            Nome          = $name
            Versao        = $_.DisplayVersion
            Publisher     = $_.Publisher
            TamanhoMB     = $sizeMb
            DataInstalacao = $installDate
        }
    }
}
$installedPrograms = $installedPrograms | Sort-Object Nome -Unique

# Deteccao de Redundancias Comuns
$browsersDetected = @()
$browserKeywords = @("Chrome", "Brave", "Firefox", "Edge", "Opera", "Vivaldi")
foreach ($b in $browserKeywords) {
    if ($installedPrograms | Where-Object { $_.Nome -like "*$b*" }) {
        $browsersDetected += $b
    }
}

$oemDetected = @()
$oemKeywords = @("Dell", "Lenovo", "HP", "Asus", "Acer", "Samsung")
foreach ($o in $oemKeywords) {
    $matches = $installedPrograms | Where-Object { $_.Publisher -like "*$o*" -or $_.Nome -like "*$o*" }
    if ($matches) {
        $oemDetected += "$o ($($matches.Count) softwares)"
    }
}

# 5. Simulacao de Ganho Consultivo em Niveis
$discoC = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
$espacoLivreAtualGB = [math]::Round($discoC.FreeSpace / 1GB, 2)
$espacoTotalGB      = [math]::Round($discoC.Size / 1GB, 2)

# Nivel 1: Risco Zero (Downloads gigantes antigos + caches sem uso ha +60d)
$ganhoNivel1MB = ($instaladoresAbandonados | Where-Object { $_.Ocioso } | Measure-Object -Property TamanhoMB -Sum).Sum
if ($null -eq $ganhoNivel1MB) { $ganhoNivel1MB = 0 }
$ganhoNivel1GB = [math]::Round($ganhoNivel1MB / 1024, 2)

# Nivel 2: Otimizado (Nivel 1 + Pastas ociosas AppData ha +90d + Desativar Hibernacao)
$pastasMuitoOciosasMB = ($pastasPesadas | Where-Object { $_.DiasSemUso -ge 90 } | Measure-Object -Property TamanhoMB -Sum).Sum
if ($null -eq $pastasMuitoOciosasMB) { $pastasMuitoOciosasMB = 0 }
$ganhoNivel2GB = [math]::Round(($ganhoNivel1MB + $pastasMuitoOciosasMB) / 1024 + $hiberGb, 2)

$projetadoNivel1GB = $espacoLivreAtualGB + $ganhoNivel1GB
$projetadoNivel2GB = $espacoLivreAtualGB + $ganhoNivel2GB

$report = [PSCustomObject]@{
    Timestamp          = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    DiscoC = [PSCustomObject]@{
        TotalGB       = $espacoTotalGB
        LivreAtualGB  = $espacoLivreAtualGB
        ProjetadoN1GB = $projetadoNivel1GB
        ProjetadoN2GB = $projetadoNivel2GB
    }
    ArquivosSistema = [PSCustomObject]@{
        HiberfilGB = $hiberGb
        PagefileGB = $pageGb
        SwapfileGB = $swapGb
    }
    SimulacaoGanhos = [PSCustomObject]@{
        NivelSeguroRiscoZeroGB  = $ganhoNivel1GB
        NivelOtimizadoEstruturalGB = $ganhoNivel2GB
    }
    Redundancias = [PSCustomObject]@{
        NavegadoresMultiplos = $browsersDetected
        SoftwaresOEM         = $oemDetected
    }
    PastasPesadasAppData   = $pastasPesadas
    InstaladoresDownloads  = $instaladoresAbandonados
}

if ($Json) {
    $report | ConvertTo-Json -Depth 4
    exit 0
}

# Saida Visual 8-Bit no Terminal
Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "|   O MECANICO: O CACADOR DE GIGABYTES (MOTOR GENERALISTA DE TUNING)     |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""
Write-Host " [STATUS DO DISCO C:] Livre: $espacoLivreAtualGB GB de $espacoTotalGB GB" -ForegroundColor $(if ($espacoLivreAtualGB -lt 30) { "Red" } else { "Green" })
Write-Host ""

Write-Host " [1. ARQUIVOS ESTRUTURAIS DO SISTEMA OPERACIONAL]" -ForegroundColor Yellow
Write-Host "  * hiberfil.sys (Arquivo de Hibernacao): $hiberGb GB" -ForegroundColor Gray
if ($hiberGb -gt 0) {
    Write-Host "    -> Dica Consultiva: Desativar a hibernacao via 'powercfg -h off' libera +$hiberGb GB instantaneamente!" -ForegroundColor Cyan
}
Write-Host "  * pagefile.sys / swapfile.sys (Memoria Virtual): $($pageGb + $swapGb) GB" -ForegroundColor Gray

Write-Host ""
Write-Host " [2. PASTAS PESADAS NO APPDATA COM FILTRO DE ABANDONO TEMPORAL]" -ForegroundColor Yellow
if ($pastasPesadas.Count -gt 0) {
    foreach ($p in ($pastasPesadas | Sort-Object TamanhoMB -Descending | Select-Object -First 8)) {
        $statusOcioso = if ($p.Ocioso) { "[OCIOSA ha $($p.DiasSemUso) dias]" } else { "[Ativa recentemente]" }
        $color = if ($p.Ocioso) { "Yellow" } else { "Gray" }
        Write-Host "  * [$($p.Origem)] $($p.Nome): $($p.TamanhoGB) GB ($($p.TamanhoMB) MB) $statusOcioso" -ForegroundColor $color
    }
} else {
    Write-Host "  Nenhuma pasta isolada acima de $MinFolderMB MB encontrada." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host " [3. INSTALADORES E ARQUIVOS ESQUECIDOS EM DOWNLOADS (> 50 MB)]" -ForegroundColor Yellow
if ($instaladoresAbandonados.Count -gt 0) {
    foreach ($i in $instaladoresAbandonados) {
        Write-Host "  * $($i.Arquivo): $($i.TamanhoMB) MB ($($i.TamanhoGB) GB) [Inativo ha $($i.DiasSemUso) dias]" -ForegroundColor Gray
    }
} else {
    Write-Host "  Nenhum instalador ou arquivo gigante esquecido em Downloads." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host " [4. AUDITORIA DE REDUNDANCIAS E FABRICANTES OEM]" -ForegroundColor Yellow
if ($browsersDetected.Count -gt 1) {
    Write-Host "  * Navegadores detectados ($($browsersDetected.Count)): $($browsersDetected -join ', ')" -ForegroundColor Gray
    Write-Host "    -> Consumo redundante de caches em navegadores secundarios." -ForegroundColor DarkGray
}
if ($oemDetected.Count -gt 0) {
    Write-Host "  * Fabricantes OEM encontrados: $($oemDetected -join ' | ')" -ForegroundColor Gray
}

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host " PROJECAO CONSULTIVA DE RECUPERACAO DE GIGAS:" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host " [NIVEL 1 - SEGURO / RISCO ZERO]       : +$ganhoNivel1GB GB  -> Espaco livre: $projetadoNivel1GB GB" -ForegroundColor Green
Write-Host " [NIVEL 2 - OTIMIZADO (+ HIBERNACAO)]  : +$ganhoNivel2GB GB  -> Espaco livre: $projetadoNivel2GB GB" -ForegroundColor Yellow
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""

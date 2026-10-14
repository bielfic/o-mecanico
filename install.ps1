<#
.SYNOPSIS
    Instalador e ativador automatico do plugin O Mecanico para Antigravity.
.DESCRIPTION
    Instala ou atualiza o plugin no diretorio oficial do Antigravity (%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico).
.PARAMETER Uninstall
    Remove o plugin do diretorio de plugins do Antigravity.
#>

[CmdletBinding()]
param(
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"

$sourceDir = $PSScriptRoot
$targetDir = Join-Path $env:USERPROFILE ".gemini\antigravity\plugins\o-mecanico"
$pluginsRoot = Join-Path $env:USERPROFILE ".gemini\antigravity\plugins"

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "|   INSTALADOR OFICIAL: O MECANICO (PC TUNING & HARDWARE DIAGNOSTIC)     |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""

if ($Uninstall) {
    if (Test-Path $targetDir) {
        Write-Host " [DESINSTALANDO] Removendo $targetDir..." -ForegroundColor Yellow
        Remove-Item -Path $targetDir -Recurse -Force
        Write-Host " [SUCESSO] Plugin O Mecanico desinstalado com sucesso." -ForegroundColor Green
    } else {
        Write-Host " [INFO] O plugin nao estava instalado em $targetDir." -ForegroundColor Gray
    }
    Write-Host ""
    exit 0
}

Write-Host " [1/3] Verificando integridade dos arquivos fonte..." -ForegroundColor Yellow
$requiredFiles = @("plugin.json", "README.md", "agents\mecanico.md", "skills\o-mecanico\SKILL.md")
foreach ($rf in $requiredFiles) {
    $fullRf = Join-Path $sourceDir $rf
    if (-not (Test-Path $fullRf)) {
        Write-Error "Arquivo obrigatorio ausente: $rf"
    }
}
Write-Host "       Todos os arquivos essenciais estao presentes." -ForegroundColor Gray

Write-Host " [2/3] Preparando diretorio de destino no Antigravity..." -ForegroundColor Yellow
if (-not (Test-Path $pluginsRoot)) {
    New-Item -ItemType Directory -Path $pluginsRoot -Force | Out-Null
}
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}
Write-Host "       Diretorio alvo: $targetDir" -ForegroundColor Gray

Write-Host " [3/3] Sincronizando arquivos do plugin..." -ForegroundColor Yellow
Copy-Item -Path (Join-Path $sourceDir "*") -Destination $targetDir -Recurse -Force
Write-Host "       Copia concluida com sucesso." -ForegroundColor Gray

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Green
Write-Host "| INSTALACAO CONCLUIDA COM SUCESSO! O MECANICO ESTA ATIVO NO SISTEMA.    |" -ForegroundColor Green
Write-Host "+========================================================================+" -ForegroundColor Green
Write-Host ""
Write-Host " Como utilizar no chat do Antigravity:" -ForegroundColor Yellow
Write-Host "   /diagnostico  -> Telemetria em tempo real de CPU, GPU, RAM e Disco" -ForegroundColor Cyan
Write-Host "   /faxina       -> Faxina segura de temporarios (Modo DryRun por padrao)" -ForegroundColor Cyan
Write-Host "   /jogar        -> Ativacao de Modo Gamer e recuperacao de RAM fisica" -ForegroundColor Cyan
Write-Host "   /processos    -> Top 10 processos por consumo de memoria e CPU" -ForegroundColor Cyan
Write-Host ""
Write-Host " Localizacao do Plugin: $targetDir" -ForegroundColor Gray
Write-Host ""

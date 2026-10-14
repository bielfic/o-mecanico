<#
.SYNOPSIS
    Script de faxina e manutencao segura do sistema operacional para o plugin O Mecanico.
.DESCRIPTION
    Remove exclusivamente arquivos temporarios e caches do sistema operacional, garantindo
    tolerancia zero de contato com dados pessoais ou documentos do usuario.
.PARAMETER DryRun
    Modo simulacao. Calcula e relata espaco que pode ser liberado sem efetuar exclusoes.
.PARAMETER Execute
    Executa a remocao efetiva dos arquivos temporarios e caches autorizados.
.PARAMETER Json
    Retorna o relatorio consolidado em formato JSON.
#>

[CmdletBinding(DefaultParameterSetName = "DryRun")]
param(
    [Parameter(ParameterSetName = "DryRun")]
    [switch]$DryRun = $true,

    [Parameter(ParameterSetName = "Execute")]
    [switch]$Execute,

    [switch]$Json
)

$ErrorActionPreference = "SilentlyContinue"

# Se o operador chamou explicitamente com -Execute, desativa o DryRun
if ($PSCmdlet.ParameterSetName -eq "Execute" -or $Execute) {
    $DryRun = $false
}

$targets = @(
    @{
        Nome      = "Temporarios do Usuario (%TEMP%)"
        Caminho   = $env:TEMP
        Filtro    = "*"
        DiasIdade = 1
    },
    @{
        Nome      = "Temporarios do Sistema (Windows\\Temp)"
        Caminho   = "$env:SystemRoot\Temp"
        Filtro    = "*"
        DiasIdade = 1
    },
    @{
        Nome      = "Crashes e Despejos de Memoria (CrashDumps)"
        Caminho   = "$env:LOCALAPPDATA\CrashDumps"
        Filtro    = "*.dmp"
        DiasIdade = 0
    },
    @{
        Nome      = "Relatorios de Erro do Windows (WER)"
        Caminho   = "$env:PROGRAMDATA\Microsoft\Windows\WER\ReportQueue"
        Filtro    = "*"
        DiasIdade = 0
    },
    @{
        Nome      = "Cache Temporario Pip (Python)"
        Caminho   = "$env:LOCALAPPDATA\pip\cache"
        Filtro    = "*"
        DiasIdade = 7
    },
    @{
        Nome      = "Cache Temporario Npm (NodeJS)"
        Caminho   = "$env:LOCALAPPDATA\npm-cache"
        Filtro    = "*"
        DiasIdade = 7
    }
)

$results = @()
$totalBytesAll = 0
$totalFilesAll = 0
$cutoffDate = (Get-Date)

foreach ($t in $targets) {
    $caminho = $t.Caminho
    $nome = $t.Nome
    $idade = $t.DiasIdade

    $bytesTarget = 0
    $countTarget = 0
    $deletedCount = 0

    if (Test-Path -Path $caminho) {
        $maxDate = (Get-Date).AddDays(-$idade)
        $items = Get-ChildItem -Path $caminho -Filter $t.Filtro -Recurse -File -Force -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -lt $maxDate }

        foreach ($file in $items) {
            $bytesTarget += $file.Length
            $countTarget++

            if (-not $DryRun) {
                try {
                    Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                    $deletedCount++
                } catch {
                    # Arquivo em uso ou bloqueado pelo sistema operacional: ignorar com seguranca
                }
            }
        }
    }

    $totalBytesAll += $bytesTarget
    $totalFilesAll += $countTarget

    $mb = [math]::Round($bytesTarget / 1MB, 2)
    $results += [PSCustomObject]@{
        Categoria         = $nome
        Caminho           = $caminho
        ArquivosEncontrados = $countTarget
        ArquivosExcluidos = if ($DryRun) { 0 } else { $deletedCount }
        EspacoLiberavelMB = $mb
    }
}

$totalMbAll = [math]::Round($totalBytesAll / 1MB, 2)
$totalGbAll = [math]::Round($totalBytesAll / 1GB, 2)

$summary = [PSCustomObject]@{
    Timestamp          = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Modo               = if ($DryRun) { "SIMULACAO (DryRun)" } else { "EXECUCAO REAL (Execute)" }
    TotalArquivos      = $totalFilesAll
    TotalEspacoMB      = $totalMbAll
    TotalEspacoGB      = $totalGbAll
    CategoriasAuditadas = $results
}

if ($Json) {
    $summary | ConvertTo-Json -Depth 4
    exit 0
}

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "|   O MECANICO: RELATORIO DE FAXINA SEGURA E AUDITORIA DE CACHE          |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""
Write-Host " Status de Operacao: $($summary.Modo)" -ForegroundColor $(if ($DryRun) { "Yellow" } else { "Green" })
Write-Host " Diretriz de Seguranca: Tolerancia Zero a dados de usuario (Docs/Desktop intocaveis)." -ForegroundColor Gray
Write-Host ""

foreach ($r in $results) {
    $statusNum = if ($DryRun) { "$($r.ArquivosEncontrados) arqs ($($r.EspacoLiberavelMB) MB)" } else { "$($r.ArquivosExcluidos)/$($r.ArquivosEncontrados) excluidos ($($r.EspacoLiberavelMB) MB)" }
    Write-Host "  * $($r.Categoria): $statusNum" -ForegroundColor Gray
}

Write-Host ""
Write-Host " TOTAL GERAL: $($summary.TotalArquivos) arquivos | $($summary.TotalEspacoMB) MB (~$($summary.TotalEspacoGB) GB)" -ForegroundColor $(if ($totalMbAll -gt 0) { "Green" } else { "Gray" })

if ($DryRun) {
    Write-Host ""
    Write-Host " [AVISO] Nenhuma exclusao foi realizada. Para efetuar a limpeza real, execute:" -ForegroundColor Yellow
    Write-Host " powershell -ExecutionPolicy Bypass -File faxina.ps1 -Execute" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host " [SUCESSO] Faxina concluida. Arquivos em uso foram preservados com seguranca." -ForegroundColor Green
}

Write-Host ""
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host "| Fim da Operacao de Faxina.                                             |" -ForegroundColor Cyan
Write-Host "+========================================================================+" -ForegroundColor Cyan
Write-Host ""

---
name: o-mecanico
description: Skill de diagnostico de hardware, cacador de gigabytes generalista, faxina segura e otimizacao gamer para Windows. Use esta skill sempre que o usuario pedir status de CPU, GPU, memoria RAM, liberacao de espaco em disco (> 10 GB), analise de softwares ociosos ou preparacao da maquina para jogos.
---

# Skill: O Mecânico (PC Tuning & Hardware Diagnostic)

Esta skill fornece ao assistente acesso a ferramentas de baixo nível no Windows para diagnóstico de telemetria, caçada inteligente de gigabytes residuais e otimização de desempenho operacional.

## Ações e Comandos Canônicos

### 1. Diagnóstico de Hardware (/diagnostico)
Coleta e exibe o estado atual da máquina:
* Processador (CPU): Modelo, núcleos lógicos/físicos, carga percentual atual.
* Placas de Vídeo (GPU/iGPU): Nome, fabricante, memória de vídeo e driver.
* Memória RAM: Capacidade instalada, memória utilizada, disponível e percentual de uso.
* Memória Virtual (Swap/Pagefile): Utilização do arquivo de paginação.
* Armazenamento: Espaço total, ocupado e livre nas unidades do sistema.

Script executor:
`powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico\skills\o-mecanico\scripts\diagnostico.ps1"`

### 2. O Caçador de Gigabytes (/pesados)
Motor generalista de auditoria profunda de espaço em disco aplicável a qualquer computador com Windows:
* Filtro de Abandono Temporal: Mapeia pastas grandes no AppData (Local/Roaming > 300 MB) e instaladores em Downloads sem uso há mais de 60, 90 ou 180 dias.
* Auditoria de Softwares Ociosos e Redundâncias: Varre o registro detectando múltiplos navegadores instalados e pacotes OEM de fabricantes (Dell, Lenovo, HP, Asus, Samsung).
* Otimizações Estruturais do Sistema: Mede o impacto de `hiberfil.sys` e `pagefile.sys`, fornecendo estimativa consultiva de ganho.
* Projeção Consultiva em Níveis: Apresenta simulação de espaço recuperável no Nível Seguro (Risco Zero) e Nível Otimizado.

Script executor:
`powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico\skills\o-mecanico\scripts\pesados.ps1"`

### 3. Faxina Segura (/faxina)
Executa auditoria e limpeza seletiva de arquivos temporários rápidos (caches de sistema e crash dumps), sem jamais tocar em dados pessoais ou documentos:
* Modo Simulação (Padrão): Calcula e exibe o total de megabytes que podem ser liberados.
  Comando: `powershell -ExecutionPolicy Bypass -File "...\scripts\faxina.ps1" -DryRun`
* Modo Execução: Remove os arquivos temporários órfãos e relata o ganho em disco.
  Comando: `powershell -ExecutionPolicy Bypass -File "...\scripts\faxina.ps1" -Execute`

### 4. Modo Gamer (/jogar)
Ajusta o ambiente operacional para extrair o máximo de fluidez gráfica e estabilidade:
* Efetua o trimming seguro de working sets inativos da memória RAM.
* Verifica o status do recurso Game Mode do Windows.
* Fornece relatório de memória recuperada antes e após a intervenção.

Script executor:
`powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico\skills\o-mecanico\scripts\gaming_mode.ps1"`

### 5. Gestão de Processos Gastadores (/processos)
Varre os 10 processos que mais consom CPU e memória no momento, identificando instâncias em segundo plano que podem ser pausadas ou encerradas com segurança.

Script executor:
`powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico\skills\o-mecanico\scripts\diagnostico.ps1" -TopProcesses`

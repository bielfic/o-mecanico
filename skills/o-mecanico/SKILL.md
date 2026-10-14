---
name: o-mecanico
description: Skill de diagnostico de hardware, faxina segura de temporarios e otimizacao gamer para Windows. Use esta skill sempre que o usuario pedir status de CPU, GPU, memoria RAM, limpeza de disco ou preparacao da maquina para jogos e alta carga.
---

# Skill: O Mecânico (PC Tuning & Hardware Diagnostic)

Esta skill fornece ao assistente acesso a ferramentas de baixo nível no Windows para diagnóstico, monitoramento de hardware e otimização de desempenho do sistema operacional.

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

### 2. Faxina Segura (/faxina)
Executa auditoria e limpeza seletiva de arquivos temporários, sem jamais tocar em dados pessoais ou documentos:
* Modo Simulação (Padrão): Calcula e exibe o total de megabytes que podem ser liberados.
  Comando: `powershell -ExecutionPolicy Bypass -File "...\scripts\faxina.ps1" -DryRun`
* Modo Execução: Remove os arquivos temporários órfãos e relata o ganho em disco.
  Comando: `powershell -ExecutionPolicy Bypass -File "...\scripts\faxina.ps1" -Execute`

### 3. Modo Gamer (/jogar)
Ajusta o ambiente operacional para extrair o máximo de fluidez gráfica e estabilidade:
* Efetua o trimming seguro de working sets inativos da memória RAM.
* Verifica o status do recurso Game Mode do Windows.
* Fornece relatório de memória recuperada antes e após a intervenção.

Script executor:
`powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico\skills\o-mecanico\scripts\gaming_mode.ps1"`

### 4. Gestão de Processos Gastadores (/processos)
Varre os 10 processos que mais consom CPU e memória no momento, identificando instâncias em segundo plano que podem ser pausadas ou encerradas com segurança.

Script executor:
`powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico\skills\o-mecanico\scripts\diagnostico.ps1" -TopProcesses`

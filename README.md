# O Mecânico (PC Tuning & Hardware Diagnostic)

```text
  ___     __  __ _____ ____   _    _   _ ___ ____ ___  
 / _ \   |  \/  | ____/ ___| / \  | \ | |_ _/ ___/ _ \ 
| | | |  | |\/| |  _|| |    / _ \ |  \| || | |  | | | |
| |_| |  | |  | | |__| |___/ ___ \| |\  || | |__| |_| |
 \___/   |_|  |_|_____\____/_/   \_\_| \_|___\____\___/ 
                                                        
        +========================================+
        |   PC TUNING & HARDWARE DIAGNOSTIC      |
        |     RETRO 8-BIT SYSTEM CO-PILOT        |
        |   ANTIGRAVITY OFFICIAL PLUGIN v1.0     |
        +========================================+
```

[![Versão](https://img.shields.io/badge/Vers%C3%A3o-1.0.0-cyan?style=for-the-badge&logo=retroarch)](https://github.com/bielfic/o-mecanico)
[![Plataforma](https://img.shields.io/badge/Plataforma-Windows%2010%20%2F%2011-blue?style=for-the-badge&logo=windows)](https://github.com/bielfic/o-mecanico)
[![PowerShell](https://img.shields.io/badge/Shell-PowerShell%205.1%2B%20%2F%20Core%207%2B-5391FE?style=for-the-badge&logo=powershell)](https://github.com/bielfic/o-mecanico)
[![Licença](https://img.shields.io/badge/Licen%C3%A7a-MIT-green?style=for-the-badge)](LICENSE)
[![Autor](https://img.shields.io/badge/Autor-%40bielfic-orange?style=for-the-badge&logo=github)](https://github.com/bielfic)

> **O Mecânico** é o plugin oficial de tuning de PC, telemetria de hardware e otimização cirúrgica de recursos do ecossistema Antigravity. Inspirado na estética retrô 8-bit dos consoles clássicos, ele entrega diagnóstico de CPU/GPU/RAM em tempo real, faxina segura de temporários com tolerância zero a tocar em dados pessoais e ativação do Modo Gamer com liberação ativa de memória física.

---

## Índice

1. [Visão Geral e Arquitetura](#visão-geral-e-arquitetura)
2. [Comandos Rápidos (Slash Commands)](#comandos-rápidos-slash-commands)
3. [Instalação de Um Comando](#instalação-de-um-comando)
4. [Tolerância Zero a Dados Pessoais](#tolerância-zero-a-dados-pessoais)
5. [Demonstração das Telas em Modo Retrô](#demonstração-das-telas-em-modo-retrô)
6. [Estrutura do Repositório](#estrutura-do-repositório)
7. [Licença e Créditos](#licença-e-créditos)

---

## Visão Geral e Arquitetura

O Mecânico atua como o engenheiro de hardware e SRE da sua estação de trabalho. Enquanto assistentes convencionais apenas conversam, O Mecânico interage diretamente com as APIs nativas do Windows (WMI, CIM, Registry e P/Invoke via `psapi.dll`), fornecendo dados reais e ajustes sem risco.

```text
       +---------------------------------------------+
       |             USUARIO / COMANDANTE            |
       +---------------------------------------------+
                              |
                     [ Slash Commands ]
                              v
       +---------------------------------------------+
       |         ANTIGRAVITY / AGENTE MECANICO       |
       |         (Ficha de Engenharia & SRE)         |
       +---------------------------------------------+
                              |
       +----------------------+----------------------+
       |                      |                      |
       v                      v                      v
[ diagnostico.ps1 ]     [ faxina.ps1 ]       [ gaming_mode.ps1 ]
  - CPU Carga & Cores     - Temp do Usuario    - Game Mode Windows
  - RAM & Swap Virtual    - Windows Temp       - Working Set Trimming
  - GPU & VRAM            - WER & Dumps        - Prioridade de Processo
  - Discos de Sistema     - Caches Pip/Npm     - RAM Fisica Recuperada
```

---

## Comandos Rápidos (Slash Commands)

Ao interagir no chat do Antigravity ou executar no terminal, você tem acesso aos seguintes comandos canônicos:

| Comando | Descrição Operacional | Ação Técnica |
| :--- | :--- | :--- |
| `/diagnostico` | Relatório completo de telemetria | Inspeciona modelo da CPU, núcleos, GPU, VRAM, RAM física, Swap e Discos |
| `/faxina` | Auditoria e limpeza segura | Modo DryRun por padrão (calcula espaço). Use `/faxina execute` para remoção |
| `/jogar` | Otimização para jogos e alta carga | Enxuga working set de processos inativos e habilita modo gamer no Windows |
| `/processos` | Top 10 processos pesados | Mapeia os maiores consumidores de memória RAM e ciclos de processamento |

---

## Instalação de Um Comando

### Opção 1: Instalação Automática Local (PowerShell)
Clone ou baixe o repositório e execute o script instalador oficial:

```powershell
# Clone o repositorio oficial
git clone https://github.com/bielfic/o-mecanico.git C:\ecossistema\plugins\o-mecanico

# Execute o instalador de um comando
powershell -ExecutionPolicy Bypass -File C:\ecossistema\plugins\o-mecanico\install.ps1
```

O script copiará os arquivos para a pasta oficial de plugins do Antigravity (`%USERPROFILE%\.gemini\antigravity\plugins\o-mecanico`) e ativará a skill automaticamente.

### Opção 2: Desinstalação Limpa
Caso deseje remover o plugin do ambiente:

```powershell
powershell -ExecutionPolicy Bypass -File C:\ecossistema\plugins\o-mecanico\install.ps1 -Uninstall
```

---

## Tolerância Zero a Dados Pessoais

A governança do Mecânico é regida pelo princípio da não invasão de privacidade e integridade absoluta do usuário:

* **PASTAS E ARQUIVOS INTOCÁVEIS:** Desktop, Documentos, Downloads, Imagens, Vídeos, Músicas, bases de dados de código e senhas.
* **ESCOPO AUTORIZADO EXCLUSIVO:** Apenas pastas temporárias comprovadas (`%TEMP%`, `C:\Windows\Temp`), caches temporários de build (`pip`, `npm`) e despejos de crash antigos (`CrashDumps`).
* **SAFETY FIRST (DRY RUN):** Nenhuma exclusão em lote é executada sem o parâmetro explícito `-Execute`. O operador sempre visualiza os megabytes calculados antes da tomada de decisão.

---

## Demonstração das Telas em Modo Retrô

### 1. Saída do Diagnóstico de Hardware (/diagnostico)
```text
+========================================================================+
|   O MECANICO: RELATORIO DE TELEMETRIA E DIAGNOSTICO DE HARDWARE        |
+========================================================================+

 [CPU] Intel(R) Processor U300
       Nucleos: 5 | Threads: 6 | Carga Atual: 42%

 [RAM] Total: 7.69 GB | Usado: 7.23 GB (94.0%) | Livre: 0.46 GB
 [SWAP] Virtual: 23.32 GB | Usado: 15.18 GB (65.1%)

 [GPU(s) DETECTADAS]
  * Intel(R) UHD Graphics (1024 MB VRAM) [Driver: 31.0.101.4953]

 [DISCOS DE ARMAZENAMENTO]
  * Unidade C: Total: 219.9 GB | Usado: 177.8 GB (80.9%) | Livre: 42 GB

+========================================================================+
| Fim da Telemetria. Sistema pronto para intervencao ou tuning.          |
+========================================================================+
```

### 2. Saída do Modo Gamer (/jogar)
```text
+========================================================================+
|   O MECANICO: ATIVACAO DE MODO GAMER E TUNING DE MEMORIA               |
+========================================================================+

 [STATUS GAMING] Ativado (Prioridade para Jogos no Windows)
 [OTIMIZACAO] Working set de 33 processos em segundo plano enxugado.

 RAM ANTES : Usada: 7230 MB (91.8%) | Livre: 646 MB
 RAM DEPOIS: Usada: 6739 MB (85.6%) | Livre: 1137 MB

 [RESULTADO] Memoria fisica liberada com sucesso: +491 MB disponiveis!

+========================================================================+
| Sistema pronto para jogos ou cargas computacionais intensas.           |
+========================================================================+
```

### 3. Saída da Faxina Segura (/faxina)
```text
+========================================================================+
|   O MECANICO: RELATORIO DE FAXINA SEGURA E AUDITORIA DE CACHE          |
+========================================================================+

 Status de Operacao: SIMULACAO (DryRun)
 Diretriz de Seguranca: Tolerancia Zero a dados de usuario (Docs/Desktop intocaveis).

  * Temporarios do Usuario (%TEMP%): 5 arqs (6.13 MB)
  * Temporarios do Sistema (Windows\Temp): 0 arqs (0 MB)
  * Crashes e Despejos de Memoria (CrashDumps): 10 arqs (125.33 MB)
  * Relatorios de Erro do Windows (WER): 0 arqs (0 MB)
  * Cache Temporario Pip (Python): 0 arqs (0 MB)
  * Cache Temporario Npm (NodeJS): 0 arqs (0 MB)

 TOTAL GERAL: 15 arquivos | 131.47 MB (~0.13 GB)

 [AVISO] Nenhuma exclusao foi realizada. Para efetuar a limpeza real, execute:
 powershell -ExecutionPolicy Bypass -File faxina.ps1 -Execute
```

---

## Estrutura do Repositório

```text
o-mecanico/
|-- plugin.json                       # Manifesto canonico do plugin Antigravity
|-- README.md                         # Apresentacao oficial em arte 8-bit e manual
|-- install.ps1                       # Instalador automatico de um comando
|-- agents/
|   `-- mecanico.md                   # Ficha do agente especialista (Hardware & SRE)
|-- rules/
|   `-- AGENTS.md                     # Regras de governanca e operacao do plugin
`-- skills/
    `-- o-mecanico/
        |-- SKILL.md                  # Especificacao canonica da skill
        `-- scripts/
            |-- diagnostico.ps1       # Telemetria de CPU, GPU, RAM, Swap e Discos
            |-- faxina.ps1            # Faxina segura com modos DryRun e Execute
            `-- gaming_mode.ps1       # Windows Game Mode e memory working set trimming
```

---

## Licença e Créditos

Distribuído sob a licença MIT. Consulte `LICENSE` para mais detalhes.

Desenvolvido para o **Ecossistema Antigravity** por **Gabriel Fic** ([@bielfic](https://github.com/bielfic)).

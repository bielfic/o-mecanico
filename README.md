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
        |   ANTIGRAVITY OFFICIAL PLUGIN v1.1     |
        +========================================+
```

[![Versão](https://img.shields.io/badge/Vers%C3%A3o-1.1.0-cyan?style=for-the-badge&logo=retroarch)](https://github.com/bielfic/o-mecanico)
[![Plataforma](https://img.shields.io/badge/Plataforma-Windows%2010%20%2F%2011-blue?style=for-the-badge&logo=windows)](https://github.com/bielfic/o-mecanico)
[![PowerShell](https://img.shields.io/badge/Shell-PowerShell%205.1%2B%20%2F%20Core%207%2B-5391FE?style=for-the-badge&logo=powershell)](https://github.com/bielfic/o-mecanico)
[![Licença](https://img.shields.io/badge/Licen%C3%A7a-MIT-green?style=for-the-badge)](LICENSE)
[![Autor](https://img.shields.io/badge/Autor-%40bielfic-orange?style=for-the-badge&logo=github)](https://github.com/bielfic)

> **O Mecânico** é o plugin oficial de tuning de PC, telemetria de hardware e otimização cirúrgica de recursos do ecossistema Antigravity. Inspirado na estética retrô 8-bit dos consoles clássicos, ele entrega diagnóstico de CPU/GPU/RAM em tempo real, ativação do Modo Gamer com liberação ativa de memória física e o poderoso **Caçador de Gigabytes**, um motor generalista que encontra de 10 a 35 GB de dados residuais esquecidos em qualquer máquina.

---

## Índice

1. [A Visão: Caçador de Gigas vs Faxina Comum de Mixaria](#a-visão-caçador-de-gigas-vs-faxina-comum-de-mixaria)
2. [Comandos Rápidos (Slash Commands)](#comandos-rápidos-slash-commands)
3. [Motor Generalista de Auditoria Profunda](#motor-generalista-de-auditoria-profunda)
4. [Instalação de Um Comando](#instalação-de-um-comando)
5. [Tolerância Zero a Dados Pessoais](#tolerância-zero-a-dados-pessoais)
6. [Demonstração das Telas em Modo Retrô](#demonstração-das-telas-em-modo-retrô)
7. [Estrutura do Repositório](#estrutura-do-repositório)
8. [Licença e Créditos](#licença-e-créditos)

---

## A Visão: Caçador de Gigas vs Faxina Comum de Mixaria

A maioria dos utilitários de limpeza de disco tradicionais limita-se a varrer pastas de `%TEMP%` ou caches rápidos do sistema. O resultado costuma ser tímido: recuperam 100 a 300 megabytes (uma verdadeira "mixaria"), deixando o usuário ainda sufocado por falta de espaço.

O Mecânico introduz uma abordagem arquitetural diferente através do comando `/pesados`:

```text
+-------------------------------------------------------------------------------+
|                       O DILEMA DA FAXINA DE DISCO NO WINDOWS                  |
+-------------------------------------------------------------------------------+
| FAXINA CONVENCIONAL DE MIXARIA        | O CACADOR DE GIGABYTES (O MECANICO)   |
+---------------------------------------+---------------------------------------+
| Escopo: %TEMP% e logs descartaveis    | Escopo: Abandono Temporal no AppData  |
| Ganho medio: 100 MB a 300 MB          | Ganho medio: 10 GB a 35 GB reais      |
| Causa: Nao resolve o disco lotado     | Causa: Mapeia instaladores > 50 MB,   |
|                                       | redundancias de navegadores, softwares|
|                                       | ociosos ha +90 dias e hiberfil.sys    |
+-------------------------------------------------------------------------------+
```

---

## Comandos Rápidos (Slash Commands)

Ao interagir no chat do Antigravity ou executar no terminal, você tem acesso aos seguintes comandos canônicos:

| Comando | Descrição Operacional | Ação Técnica |
| :--- | :--- | :--- |
| `/pesados` | O Caçador de Gigabytes | Auditoria profunda generalista: abandono temporal no AppData, instaladores e redundâncias (> 10 GB) |
| `/diagnostico` | Relatório completo de telemetria | Inspeciona modelo da CPU, núcleos, GPU, VRAM, RAM física, Swap e Discos |
| `/jogar` | Otimização para jogos e alta carga | Enxuga working set de processos inativos e habilita modo gamer no Windows |
| `/faxina` | Auditoria e limpeza de temporários | Modo DryRun por padrão (calcula espaço). Use `/faxina execute` para remoção |
| `/processos` | Top 10 processos pesados | Mapeia os maiores consumidores de memória RAM e ciclos de processamento |

---

## Motor Generalista de Auditoria Profunda

Projetado para funcionar com precisão cirúrgica em qualquer computador com Windows 10 ou 11, sem depender de pastas ou softwares específicos:

1. **Filtro de Abandono Temporal:** Varre pastas grandes no AppData (Local e Roaming > 300 MB) e instaladores em Downloads, medindo o carimbo de data/hora do arquivo mais recente para aferir inatividade real (pastas sem uso há mais de 60, 90 ou 180 dias).
2. **Auditoria de Softwares via Registro:** Lê os programas instalados no Windows identificando softwares redundantes (múltiplos navegadores consumindo gigabytes em duplicidade) e pacotes de fabricantes OEM (Dell, HP, Lenovo, Samsung, Asus).
3. **Otimizações Estruturais do Sistema:** Analisa o tamanho do arquivo de hibernação (`hiberfil.sys`) e arquivos de memória virtual (`pagefile.sys`), calculando o ganho exato de espaço caso a hibernação seja dispensável.
4. **Projeção Consultiva em Dois Níveis:**
   * **Nível 1 (Seguro / Risco Zero):** Downloads gigantes antigos e caches órfãos.
   * **Nível 2 (Otimizado Estrutural):** Aplicações ociosas há +90 dias somadas ao ganho de hibernação.

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

* **PASTAS E ARQUIVOS INTOCÁVEIS:** Desktop, Documentos, Downloads de trabalho, Imagens, Vídeos, Músicas, bases de dados de código e senhas.
* **ESCOPO AUTORIZADO EXCLUSIVO:** Apenas pastas temporárias comprovadas (`%TEMP%`, `C:\Windows\Temp`), caches temporários de build (`pip`, `npm`) e despejos de crash antigos (`CrashDumps`).
* **SAFETY FIRST (DRY RUN):** Nenhuma exclusão em lote é executada sem o parâmetro explícito `-Execute`. O operador sempre visualiza os megabytes calculados antes da tomada de decisão.

---

## Demonstração das Telas em Modo Retrô

### 1. Saída do Caçador de Gigabytes (/pesados)
```text
+========================================================================+
|   O MECANICO: O CACADOR DE GIGABYTES (MOTOR GENERALISTA DE TUNING)     |
+========================================================================+

 [STATUS DO DISCO C:] Livre: 41.87 GB de 219.85 GB

 [1. ARQUIVOS ESTRUTURAIS DO SISTEMA OPERACIONAL]
  * hiberfil.sys (Arquivo de Hibernacao): 0 GB
  * pagefile.sys / swapfile.sys (Memoria Virtual): 0 GB

 [2. PASTAS PESADAS NO APPDATA COM FILTRO DE ABANDONO TEMPORAL]
  * [AppData\Local] Programs: 6.45 GB (6600.4 MB) [Ativa recentemente]
  * [AppData\Roaming] stremio: 6.16 GB (6310.2 MB) [OCIOSA ha 124 dias]
  * [AppData\Local] Packages: 5.04 GB (5161 MB) [Ativa recentemente]
  * [AppData\Local] Microsoft: 4.75 GB (4865.9 MB) [Ativa recentemente]
  * [AppData\Roaming] .minecraft: 2.93 GB (2998 MB) [OCIOSA ha 282 dias]
  * [AppData\Local] BraveSoftware: 1.55 GB (1591.7 MB) [Ativa recentemente]
  * [AppData\Local] Google: 1.08 GB (1105.5 MB) [Ativa recentemente]
  * [AppData\Roaming] .tlauncher: 1.07 GB (1093.6 MB) [OCIOSA ha 282 dias]

 [3. INSTALADORES E ARQUIVOS ESQUECIDOS EM DOWNLOADS (> 50 MB)]
  Nenhum instalador ou arquivo gigante esquecido em Downloads.

 [4. AUDITORIA DE REDUNDANCIAS E FABRICANTES OEM]
  * Navegadores detectados (3): Chrome, Brave, Edge
    -> Consumo redundante de caches em navegadores secundarios.
  * Fabricantes OEM encontrados: Samsung (14 softwares)

+========================================================================+
 PROJECAO CONSULTIVA DE RECUPERACAO DE GIGAS:
+========================================================================+
 [NIVEL 1 - SEGURO / RISCO ZERO]       : +0 GB  -> Espaco livre: 41.87 GB
 [NIVEL 2 - OTIMIZADO (+ HIBERNACAO)]  : +13.18 GB  -> Espaco livre: 55.05 GB
+========================================================================+
```

### 2. Saída do Diagnóstico de Hardware (/diagnostico)
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

### 3. Saída do Modo Gamer (/jogar)
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

---

## Estrutura do Repositório

```text
o-mecanico/
|-- plugin.json                       # Manifesto canonico do plugin Antigravity v1.1.0
|-- README.md                         # Apresentacao oficial em arte 8-bit e manual
|-- install.ps1                       # Instalador automatico de um comando
|-- LICENSE                           # Licenca MIT oficial
|-- agents/
|   `-- mecanico.md                   # Ficha do agente especialista (Hardware & SRE)
|-- rules/
|   `-- AGENTS.md                     # Regras de governanca e operacao do plugin
`-- skills/
    `-- o-mecanico/
        |-- SKILL.md                  # Especificacao canonica da skill com /pesados
        `-- scripts/
            |-- pesados.ps1           # O Cacador de Gigabytes (Motor Generalista)
            |-- diagnostico.ps1       # Telemetria de CPU, GPU, RAM, Swap e Discos
            |-- faxina.ps1            # Faxina segura com modos DryRun e Execute
            `-- gaming_mode.ps1       # Windows Game Mode e memory working set trimming
```

---

## Licença e Créditos

Distribuído sob a licença MIT. Consulte `LICENSE` para mais detalhes.

Desenvolvido para o **Ecossistema Antigravity** por **Gabriel Fic** ([@bielfic](https://github.com/bielfic)).

# Modularizacao dos Sistemas - Lloegrys

## Visao Geral
- Objetivo: transformar os sistemas existentes em bibliotecas modulares, documentadas e reutilizaveis para suportar novas features sem gambiarras.
- Escopo inicial: Atributos, Fama, Magias, Equipamentos, Artefatos e o ecossistema da Dungeon (floors, eventos e recompensas).
- Premissa: modularizacao deve acontecer em paralelo com a producao de conteudo; por isso cada fase inclui entregaveis pequenos e validacao conjunta (Rodrigo + Shiv).

## Inventario dos Sistemas Atuais

### Atributos
- **Responsabilidade**: gerenciar pontos primarios (STR, DEX, INT) e secundarios (LCK, CON, SPR, WIS) e gates de equipamento/magia.
- **Arquivos principais**:
  - `creaturescripts/scripts/login.lua` (setup inicial e reset de storages).
  - `creaturescripts/scripts/levelup.lua` (distribuicao de pontos por level).
  - `npc/scripts/the_oracle.lua`, `npc/scripts/alim.lua` (gasto e compra de pontos).
  - `weapons/scripts/*.lua`, `spells/scripts/spells/*.lua` (checar requisitos de atributo).
- **Storages chave**:
  - Pontos disponiveis: `39900` (primario) e `39901` (secundario).
  - Valores alocados: `40000` a `40006`.
  - Flag de controle por level: `50`.
- **Fluxo atual**: scripts hard-coded adicionam ou consomem pontos; cada arquivo replica a mesma logica para checar requisitos.
- **Dores**:
  - Requisito de atributo duplicado em dezenas de scripts.
  - Sem API unica para conceder, consumir ou validar pontos.
  - Dificil testar porque depende de storages magicos espalhados.

### Fama
- **Responsabilidade**: moeda de progressao para promocoes de classe, perks extras e trocas.
- **Arquivos principais**:
  - `movements/scripts/*floorexitportal.lua` e `creaturescripts/scripts/task*.lua` (recompensas).
  - `npc/scripts/alim.lua`, `npc/scripts/the_oracle.lua`, `npc/scripts/rabia.lua` (gastos e conversoes).
  - `talkactions/scripts/stats.lua` (exibicao para o jogador).
- **Storages chave**:
  - Fama atual: `39903`.
  - Fama total historica: `39911`.
- **Fluxo atual**: cada script concede/consome fama diretamente e gerencia mensagens; nao ha controle central sobre cap, historico ou auditoria.
- **Dores**:
  - Dificil alterar balanceamento sem percorrer todos os scripts.
  - Nao existe camada de negocio para validar limites ou triggers (ex: atualizar `totalfame` sempre).

### Magias
- **Responsabilidade**: definicao de spells de jogador (aprendizado, requisitos, efeitos, cooldowns).
- **Arquivos principais**:
  - `spells/spells.xml` (cadastro e metadata).
  - `spells/scripts/spells/*.lua`, `spells/scripts/skills/*.lua` (implementacao).
  - `creaturescripts/scripts/levelup.lua` (aprendizado por skill).
  - `talkactions/scripts/spells.lua` (listagem).
- **Storages chave**:
  - Cooldowns: faixa `80000+`.
  - Flags de aprendizado: `playerLearnInstantSpell` (base TFS) + storages especificos por spell.
- **Fluxo atual**: scripts verificam requisitos (mana, atributos, vocacao, itens) manualmente; cooldown e gating replicados.
- **Dores**:
  - Estrutura monolitica em XML + scripts longos (ex: `fireball.lua` ~300 linhas).
  - Nao ha configuracao compartilhada por elemento/classe.
  - Dificil reutilizar logica de custo/criticos/elementos.

### Equipamentos
- **Responsabilidade**: gating por atributo, efeitos especiais (critico extra, recarga de SP), interacao com artefatos.
- **Arquivos principais**:
  - `weapons/scripts/*.lua`, `items/items.xml` (regras de uso).
  - `lib/core/*.lua`, `global.lua` (checks globais).
- **Storages chave**:
  - Atributos (series 40000) e flags de artefatos (50900+).
- **Fluxo atual**: cada tipo de arma tem script proprio com grandes blocos `if` para atributo, vocacao, buffs.
- **Dores**:
  - Duplicacao alta entre scripts (e.g. logica de `Pure Mana` e `Bloodstone`).
  - Sem registro central de requisitos ou efeitos passivos -> ajustes exigem varrer todos os arquivos.

### Artefatos
- **Responsabilidade**: itens unicos que habilitam perks permanentes (danos extras, spells novos, bonus economicos).
- **Arquivos principais**:
  - `npc/scripts/rabia.lua` (binding, upgrade e reset).
  - `talkactions/scripts/stats.lua` (descricao ativa).
  - `weapons/scripts/*`, `spells/scripts/*`, `movements/scripts/*` (aplicar efeitos).
- **Storages chave**: `50900` a `50912` (estados -1, 0, 1, 10).
- **Fluxo atual**: cada local consulta diretamente o storage e aplica efeito; ausencia de API gera divergencias (ex: mensagens diferentes, sem debounce).
- **Dores**:
  - Estado com varios magic numbers (-1,0,1,10) dificil de entender.
  - Sem camada que descreva prerequisitos, efeito e ganchos de evento.

### Dungeon (Floors, Eventos, Rewards)
- **Responsabilidade**: progressao de andares, puzzles, tasks, resets, coffers, storages de chaves.
- **Arquivos principais**:
  - `movements/scripts/*portal*.lua`, `movements/scripts/*switch*.lua`.
  - `actions/scripts/quests/*.lua`, `actions/scripts/other/*.lua`.
  - `globalevents/scripts/*.lua`, `events/scripts/player.lua`.
  - `world/worldchanges/*.xml`.
  - Docs auxiliares: `Storage List.lua`, `Taskboard.lua`, `First Ascent.lua`.
- **Storages chave**: faixas 46000-48299 (triggers por floor), 55000-55030 (Ascent), 47000+ (UIDs), 50000+ (cofres).
- **Fluxo atual**: regras espalhadas; cada script manipula storages diretamente e assume valores hard-coded; dificil visualizar dependencias.
- **Dores**:
  - Manutencao arriscada (ex: mesmo storage usado em multiplos scripts sem contrato).
  - Quase nenhuma automatizacao para reset/rollback.
  - Documentacao atual (arquivos .lua de referencia) nao esta sincronizada com implementacao.

## Problemas Transversais
- Uso extensivo de storages numericos sem constantes nem comentarios.
- Falta de uma camada `lib` especifica para gameplay (apenas `core` e `compat` estao em uso).
- Scripts enormes e com responsabilidades misturadas (ex: `levelup.lua` mistura aprendizado, atributos e mensagens).
- Dificuldade para testar em sandbox (nao ha fixtures ou comandos de debug para simular estados).
- Conhecimento tacito concentrado no Rodrigo (risco alto se ficar sem tempo).

## Diretrizes de Modularizacao
1. **Criar modulo `data/lib/gameplay`** com submodulos por sistema (ex: `gameplay.attributes`, `gameplay.fame`). Cada modulo deve expor:
   - Constantes (storages, valores padrao).
   - Funcoes puras (calcular custo, checar limites).
   - Funcoes de efeito (conceder pontos, registrar fama) com logging.
2. **Adotar registros declarativos** (tabelas Lua) para requisitos de armas, spells e artefatos. Scripts passam a consumir a configuracao em vez de ifs soltos.
3. **Padronizar eventos**: funcoes `onPlayerLevelUp`, `onFloorClear`, `onTaskComplete` chamam modulos em vez de manipular storages.
4. **Documentacao viva**: cada modulo inclui README curto (`docs/<modulo>.md`) com tabela de storages e ganchos.
5. **Ferramentas de suporte**:
   - Talkaction `!debugstate` para exibir storages relevantes via API central.
   - Script utilitario para verificar sobreposicao de storages.
6. **Criterios de pronto**:
   - Scripts consumidores usam apenas funcoes do modulo.
   - Cobertura manual: comando GM para rodar self-check e imprimir estado dos modulos.

## Roadmap Proposto

### Fases Resumidas

| Fase | Objetivo | Entregaveis chave | Responsavel | Esforco estimado* |
| --- | --- | --- | --- | --- |
| 0 | Preparacao | Mapear storages em planilha, alinhar naming, criar doc deste arquivo | Shiv | 0.5 semana |
| 1 | Fundacao | Estrutura `data/lib/gameplay`, helper de logging, testes simples em console | Shiv (codar) + Rodrigo (review) | 1 semana |
| 2 | Atributos | API `Attributes`, migrar `levelup.lua` e `npc` relevantes, normalizar checks de requisito | Conjunto (pair) | 1.5 semanas |
| 3 | Fama | API `Fame`, centralizar ganhos/gastos, atualizar NPCs e tasks, gerar relatorio `!fame` | Shiv (core) + Rodrigo (balance) | 1 semana |
| 4 | Magias | Config declarativa por spell, mover cooldowns p/ modulo, limpar scripts principais (top 10 spells) | Rodrigo (design) + Shiv (infra) | 2-3 semanas |
| 5 | Equipamentos | Tabela de requisitos e efeitos passivos, migrar armas base (melee e ranged), remover duplicacoes | Shiv (infra) + Rodrigo (validar gameplay) | 2 semanas |
| 6 | Artefatos | FSM clara (enum estados), modulo `Artifacts`, hooks unificados, UI em `!stats` consumindo API | Conjunto | 1.5 semanas |
| 7 | Dungeon | Catalogar eventos, criar `DungeonModule` com funcoes de onboarding/reset, automatizar Ascent | Rodrigo (mapa) + Shiv (sistematizacao) | 3+ semanas |

_*Esforco estimado em tempo corrido com disponibilidade limitada (no max 8-10h semanais cada)._

### Marcos Detalhados
- **M0 (Dia 0-3)**: consolidar inventario de storages (usando `Storage List.lua` como base, validar gaps) e abrir issues por sistema.
- **M1 (Semana 1)**: `gameplay/_init.lua` carregado em `lib.lua`; logger simples (`GameLog.info`).
- **M2 (Semana 2-3)**: `Attributes` com funcoes `assignPoint`, `refundPoint`, `checkRequirement`; scripts de armas usam `Attributes.meetsRequirement`.
- **M3 (Semana 4)**: tabela `fame_sources.lua`; NPCs usam `Fame.spend` que atualiza `totalfame`; comando `!fame`.
- **M4 (Semana 5-7)**: spells principais usam builder `SpellConfig.define`; cooldowns armazenados em tabela; documentar pipeline para novas magias.
- **M5 (Semana 8-9)**: `Equipment.registerCategory` com hooks de `onEquip`/`onUnequip`.
- **M6 (Semana 10-11)**: `Artifacts` com `bind`, `toggle`, `isActive`; NPC Rabia migrado.
- **M7 (Semana 12+)**: mapa de flows da dungeon, separar puzzles em modulos (`Dungeon.Floor1`, etc.) e planejar resets automaticos.

### Dependencias e Riscos
- Necessidade de ambiente de teste rapido (sugestao: criar world reduzido so com NPCs e target dummies).
- Qualquer mudanca em weapon scripts impacta balanceamento; precisa de validacao manual (pelo menos 1h playtest).
- Roadmap pressupoe que Rodrigo continua produzindo design; caso workload aumente, priorizar Fases 2,3,5 (gado e gating) e adiar spell/dungeon modular.

## Proximos Passos Imediatos
- Rodrigo: revisar esta documentacao e complementar com gaps conhecidos (especialmente storages da dungeon).
- Shiv: criar prototipo do modulo `gameplay.attributes` com constantes e funcao `debugPrint`.
- Ambos: alinhar agenda semanal (pair de 2h) para tocar migracoes sem bloquear producao de mapas.


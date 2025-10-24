# Roadmap de Refatoração — Sistema de Elementos

Este roadmap orienta a mudança do sistema atual (elemento e oposto) para um modelo onde o jogador pode selecionar quaisquer DOIS elementos ativos simultaneamente, sem restrição de opostos.

## Objetivo
- Permitir até 2 elementos ativos por jogador, escolhidos livremente.
- Remover dependência de elementos opostos e de `negstr` nos spellbooks.
- Centralizar a lógica de seleção/checagem em uma biblioteca única.

## Contexto Atual (referências)
- IDs de storages por elemento usados hoje:
  - Fire `40210`, Water `40211`, Earth `40213`, Wind `40214`, Holy `40215`, Death `40216` (ver `_bin/data/Storage List.lua:342`–`:347`).
- Spellbooks definem `elestr` e `negstr` e acessam `getPlayerStorageValue`/`setPlayerStorageValue` diretamente. Exemplos:
  - `_bin/data/actions/scripts/spellbooks/scorching_ray.lua:10`–`:13` (`elestr = 40210`, `negstr = 40211`).
  - `_bin/data/actions/scripts/spellbooks/water_gush.lua:10`–`:13` (`elestr = 40211`, `negstr = 40210`).
  - Padrão repete-se para Earth/Wind, Holy/Death etc.

## Diretrizes de Design
- Configurável: `MAX_SELECTED_ELEMENTS = 2` (padrão) e por vocação via config.
- Fonte de verdade única para elementos selecionados por jogador.
  - Fase 1: manter storages por elemento (compatibilidade).
  - Fase 2: migrar para bitmask em 1 storage novo (ex.: `40217`) com 6 bits (Fire, Water, Earth, Wind, Holy, Death).
- API central (lib) para leitura/gravação; spellbooks não acessam storages diretamente.
 - Sem deseleção: jogadores não podem remover elementos após selecionar (apenas via intervenção admin, se aplicável).
 - Elementalist: limite especial de 3 elementos (demais vocações seguem o padrão 2).
 - Warlock: reservar placeholder de bônus em `Elements.CONFIG (lib)` para compensação futura.

## Plano por Fases

### Fase 0 — Mapeamento e critérios
- Status: CONCLUIDA
- Mapear todas as ocorrências de `elestr`/`negstr` e dos IDs `40210/40211/40213/40214/40215/40216`.
- Critérios de aceite:
  - Jogador pode selecionar quaisquer 2 elementos; sem bloqueio por oposto.
  - Tentar selecionar um 3º elemento retorna feedback claro e não altera estado.
  - Spellbooks interagem apenas via a lib central de elementos.

### Fase 1 — Biblioteca central de elementos (backend v1 por storages)
- Status: CONCLUIDA
  - Implementado `Elements.get_max_selected(cid)` lendo `Elements.CONFIG (lib)`.
  - `unselect_element`/`toggle_element` não permitem deseleção (bloqueados na lib).
- Criar `
  _bin/data/lib/elements.lua` com:
  - Constantes: `ELEMENT = { FIRE=40210, WATER=40211, EARTH=40213, WIND=40214, HOLY=40215, DEATH=40216 }`.
  - Config: `MAX_SELECTED_ELEMENTS = 2`.
  - Funções:
    - `get_selected_elements(cid) -> {ids}`
    - `is_selected(cid, id) -> boolean`
    - `count_selected(cid) -> number`
    - `can_select_more(cid) -> boolean`
    - `select_element(cid, id) -> ok|err, msg`
    - `unselect_element(cid, id) -> ok|err, msg`
    - `toggle_element(cid, id) -> ok|err, msg`
  - Mensagens padrão de feedback (localizáveis).

### Fase 2 — Refatorar spellbooks para usar a lib
- Status: CONCLUIDA
  - Mensagens genéricas (sem número fixo), respeitando limite dinâmico.
- Em cada spellbook:
  - Remover `negstr` e checagens de oposto.
  - Substituir `elestr = <id>` por `local E = require('lib/elements')` e chamar `E.select_element(cid, E.ELEMENT.<ELEMENTO>)` ou `E.toggle_element(...)` conforme a intenção.
  - Atualizar mensagens: "Elemento adicionado", "Elemento já ativo", "Limite de 2 atingido".
- Começar por alguns arquivos para validar o padrão (ex.: `scorching_ray.lua`, `water_gush.lua`, `wrath_of_nature.lua`, `smite.lua`, `sudden_death.lua`).

### Fase 3 — Remover a restrição de opostos
- Status: CONCLUIDA
- Excluir leituras e bloqueios de `negstr` em todos os spellbooks.
- Remover mensagens de erro relacionadas a elementos opostos.

### Fase 4 — Validação de regras
- Status: PENDENTE
 - Validar que Elementalist consegue selecionar 3 elementos e demais vocações, 2.
 - Confirmar que não há caminho de deseleção pelo jogador.
- Testes manuais:
  - Seleções válidas: Fire+Water, Earth+Wind, Holy+Death e combinações antes proibidas.
  - Tentar selecionar um 3º elemento: rejeitar com mensagem.
  - Alternância: selecionar, deselecionar, selecionar novamente.
- Ferramenta de teste admin: reutilizar `_bin/data/actions/scripts/tools/testing.lua` para set/reset de storages.

### Fase 5 — Migração para bitmask (backend v2)
- Status: PENDENTE
- Introduzir storage `40217` como bitmask (bit 0 Fire, 1 Water, 2 Earth, 3 Wind, 4 Holy, 5 Death).
- Implementar backend v2 na `lib/elements.lua` (adaptando as mesmas funções) para ler/gravar a bitmask.
- Migração:
  - Ao logar (ou na 1ª chamada), ler v1 (storages por elemento), montar bitmask v2 e gravar `40217`.
  - Período de compat: leitura v2; escrita em v1+v2 para não quebrar legado.
  - Após estabilizar, remover escrita v1 e manter somente v2.
- Documentar depreciação de `40210`–`40216` como fonte de verdade.

### Fase 6 — UI/UX e comunicação
- Status: PENDENTE
 - Comunicar que escolhas de elementos são permanentes (sem deseleção) e o limite por vocação.
 - Comunicar compensação planejada para Warlock (placeholder em `Elements.CONFIG (lib)`).
- Mensagens claras ao atingir o limite de 2 e ao (des)selecionar.
- Changelog/comunicado aos jogadores: qualquer combinação é válida; limite de 2 elementos.

### Fase 7 — Balanceamento
- Status: PENDENTE
- Avaliar novas sinergias (ex.: Fire+Water, Holy+Death) em PVE/PVP.
- Ajustar dano, cooldowns e efeitos se necessário.
- Verificar dependências em conteúdo (quests/portas/NPCs) que assumam opostos.

### Fase 8 — Testes e rollout
- Status: PENDENTE
- Checklist de regressão:
  - Todos os spellbooks respeitam `MAX_SELECTED_ELEMENTS`.
  - Não há referências restantes a `negstr`.
  - Migração mantém corretamente os elementos ativos do jogador.
- Rollout gradual (se possível) com logs/telemetria de seleção para monitorar uso.

### Fase 9 — Limpeza
- Status: PENDENTE
- Remover código morto/condições de opostos.
- Confirmar que buscas por `negstr` retornam vazio.
- Atualizar documentação e comentários nos scripts.

## Riscos e Mitigações
- Dados legados inconsistentes: migração idempotente v1 → v2 em login e ferramenta admin para correções.
- Exploits de sinergia: balanceamento ativo e monitoramento pós-rollout.
- Dependências ocultas de opostos: busca ampla e revisão de conteúdo dependente.

## Entregáveis por Marco
- M1: `lib/elements.lua` (backend v1) + 1–2 spellbooks refatorados (prova de conceito). Status: CONCLUIDO
- M2: Todos os spellbooks migrados para a lib, sem `negstr`. Status: CONCLUIDO
- M3: Backend v2 (bitmask `40217`) implementado + migração (leituras v2, escrita v1+v2). Status: PENDENTE
- M4: Cutover para bitmask, limpeza final e documentação atualizada. Status: PENDENTE
 - Extra: `Elements.CONFIG (lib)` com `ELEMENTS_MAX_SELECTED_DEFAULT = 2`, override de Elementalist (3) e `WARLOCK_COMPENSATION_BONUS` placeholder. Status: CONCLUIDO

## Próximos Passos Sugeridos
- Executar Fase 4: validar manualmente as combinações e o bloqueio do 3º elemento.
- Planejar/implementar Fase 5: backend v2 com bitmask (storage único 40217) + migração.
- Preparar mensagens UX adicionais (confirmações/feedback) e documentação aos jogadores (Fase 6).
- Definir checklist de balanceamento para novas sinergias (Fase 7) e plano de rollout (Fase 8).




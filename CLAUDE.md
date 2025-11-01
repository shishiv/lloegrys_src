# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Lloegrys Docker** is a custom Open Tibia Server (TFS-based) with extensive gameplay modifications. The project is containerized with Docker and includes a complete stack (server, database, web interface). The codebase is primarily **Lua scripting** on top of TFS (The Forgotten Server) C++ engine.

**Current State**: Mid-migration from legacy scripts to modular APIs. Equipment system partially implemented, attributes system operational, 70% code duplication in weapon scripts pending consolidation.

## Architecture Overview

### Module Initialization Chain

The server loads Lua modules in a specific order during startup:

```
data/lib/lib.lua (entry point)
  ├─ data/lib/gameplay/logger.lua (FIRST - provides GameLog)
  ├─ data/lib/core/core.lua (TFS API extensions)
  ├─ data/lib/compat/compat.lua (legacy compatibility)
  └─ data/lib/gameplay/_init.lua (gameplay foundation)
       ├─ storages.lua (centralized storage IDs)
       ├─ storage_audit.lua (validation helpers)
       ├─ storage.lua (storage helpers)
       ├─ attributes.lua (player stat management)
       ├─ fame.lua (fame system)
       ├─ fame_sources.lua (fame definitions)
       ├─ slayer.lua (task system)
       ├─ elements.lua (elemental system)
       ├─ spellbooks.lua (spell management)
       └─ equipment.lua (equipment system - PARTIAL)
```

### Core Gameplay Systems

**1. Attributes System** (`_bin/data/lib/gameplay/attributes.lua`)
- Manages 7 player stats: STR, DEX, INT, LCK, CON, SPR, WIS
- Storage IDs: 40000-40006 (centralized in `Storages.ATTRIBUTES`)
- Key APIs:
  - `Attributes.ensureRequirements(player, requirements, opts)` - Validates with user feedback
  - `Attributes.meetsRequirements(player, requirements)` - Silent validation
  - `Attributes.get(player, attribute)` - Read attribute value
  - `Attributes.add(player, attribute, value)` - Modify attribute

**2. Equipment System** (`_bin/data/lib/gameplay/equipment.lua`)
- **Status**: PARTIAL IMPLEMENTATION (started but incomplete)
- Declarative weapon/armor definitions with requirements, stats, effects
- Registration pattern: `Equipment.register(itemid, properties)`
- Definition files: `_bin/data/lib/gameplay/definitions/equipment_*.lua`
- Key APIs:
  - `Equipment.get(itemid)` - Retrieve item properties
  - `Equipment.meetsRequirements(player, itemid, itemName)` - Validates with feedback
  - `Equipment.onEquip(player, item)` - TODO: Passive effects on equip
  - `Equipment.onUnequip(player, item)` - TODO: Remove effects on unequip
  - `Equipment.onUseWeapon(player, variant)` - TODO: Replace weapon script logic

**3. Storage System** (`_bin/data/lib/gameplay/storages.lua`)
- Centralized storage ID definitions to replace magic numbers
- Organized by category: CORE, ATTRIBUTES, GEMS, COMBAT, ELEMENTS, SUMMONS, COOLDOWNS, POTIONS, SLAYER_TASKS
- Usage: `Storages.ATTRIBUTES.DEXTERITY` instead of `40001`

**4. Logging System** (`_bin/data/lib/gameplay/logger.lua`)
- Global `GameLog` object with levels: error, warn, info, debug
- Usage: `GameLog.debug("message", "context")`, `GameLog.info("message", "context")`
- Configuration via `GAMEPLAY_LOG_LEVEL` environment variable or config
- All module loads use `GameLog.debug('Loaded module.lua', 'init:namespace')`

### Event Hooks System

TFS provides hooks for intercepting player actions (`_bin/data/events/events.xml`):

**Enabled Hooks**:
- `Player:onMoveItem` - Intercepts item movement (currently validates equipment requirements)
- `Player:onLook` - Custom look descriptions
- `Player:onGainExperience` - Experience modifiers
- `Player:onGainSkillTries` - Skill advancement

**Equipment Validation Flow**:
```
Player drags item to equipment slot
  → onMoveItem hook (_bin/data/events/scripts/player.lua:102-119)
  → Check if toPosition.x in EQUIPMENT_SLOTS
  → Equipment.meetsRequirements(player, itemId, itemName)
  → Attributes.ensureRequirements(player, reqs, {action="equip", subject=itemName})
  → Return false to block equip, true to allow
```

### Weapon Script Architecture

**Current State**: 29 weapon scripts with 70% code duplication (~4,050 duplicate lines)

**Legacy Pattern** (in `_bin/data/weapons/scripts/*.lua`):
```lua
function onUseWeapon(cid, variant)
    local player = Player(cid)
    -- 15-20 redundant slot lookups
    local weapon = player:getSlotItem(CONST_SLOT_LEFT)
    -- Direct storage access (anti-pattern)
    local dexterity = player:getStorageValue(40001) or 0
    -- Hardcoded combat logic
    -- ... 150-300 lines per weapon type
end
```

**Target Pattern** (Equipment system):
```lua
-- In definitions/equipment_daggers.lua
Equipment.register(7384, {
    requirements = {dexterity = 2},
    stats = {attack = 25, defense = 15},
    crit = {chance = 25, multiplier = 2.75},
    effects = {onHit = {...}}
})

-- In weapons/scripts/daggers.lua (simplified)
function onUseWeapon(cid, variant)
    return Equipment.onUseWeapon(Player(cid), variant)
end
```

## Critical File Locations

**Never Edit Directly** (managed by migrations):
- `_bin/data/weapons/scripts/*.lua` - Weapon scripts (pending Equipment migration)

**Configuration Files** (require XML registration):
- `_bin/data/talkactions/talkactions.xml` - Register player commands (!command) and admin commands (/command)
- `_bin/data/events/events.xml` - Enable/disable event hooks
- `_bin/data/weapons/weapons.xml` - Map item IDs to weapon scripts

**Safe to Modify** (modular APIs):
- `_bin/data/lib/gameplay/*.lua` - Gameplay modules
- `_bin/data/lib/gameplay/definitions/*.lua` - Declarative equipment/spell definitions
- `_bin/data/talkactions/scripts/*.lua` - Command implementations

## Development Workflow

### Adding New Equipment

1. **Define equipment properties** in `_bin/data/lib/gameplay/definitions/equipment_*.lua`:
   ```lua
   Equipment.register(ITEM_ID, {
       requirements = {dexterity = 2, level = 20},
       stats = {attack = 30, defense = 18},
       crit = {chance = 30, multiplier = 3.0},
       effects = {onHit = {...}}
   })
   ```

2. **Register in weapons.xml** (if new item):
   ```xml
   <melee id="ITEM_ID" script="daggers.lua"/>
   ```

3. **Test validation**: Try equipping without requirements, verify message appears

### Adding Admin Commands

1. **Create script** in `_bin/data/talkactions/scripts/command_name.lua`:
   ```lua
   function onSay(player, words, param)
       if not player:getGroup():getAccess() then
           return false
       end
       -- Command logic
       GameLog.info("Admin used command", "Commands")
       return false
   end
   ```

2. **Register in talkactions.xml**:
   ```xml
   <talkaction words="/command" separator=" " script="command_name.lua" />
   ```

### Adding Player Commands

Same as admin commands but:
- No access check: `player:getGroup():getAccess()`
- Use `!command` prefix instead of `/command`
- Register in player talkactions section of XML

### Adding Logging

Always use GameLog for debugging and monitoring:
```lua
if GameLog and GameLog.debug then
    GameLog.debug(string.format("Player %s action", player:getName()), "SystemName")
end

if GameLog and GameLog.info then
    GameLog.info("Important event occurred", "SystemName")
end
```

## Active Development Context

### Completed (EPIC 1)
- ✅ Fixed syntax error in equipment.lua (missing `end` statement)
- ✅ Equipment validation hook (Player:onMoveItem) blocks invalid equips
- ✅ Personalized requirement messages with item names

### In Progress (Current Tasks)
- 🔄 Admin `/validateEquipment` command - Check and remove invalid equipped items
- 🔄 GameLog integration - Add logging to equipment validation flow
- 🔄 `!checkAttributes` command - Player command to view their attributes
- 📋 TASK-012: Implement !checkAttributes (from roadmap_v2.md Phase 2)

### Pending (Next Priorities from roadmap_v2.md)
- **Phase 2 (Attributes)**: Audit all weapon/spell scripts, replace direct storage access with Attributes API
- **Phase 5 (Equipment)**: Complete Equipment.onEquip/onUnequip, implement Effects system
- **Weapon Consolidation**: Reduce 5,800 lines across 29 scripts to ~1,750 lines (70% reduction)

## Common Patterns

### Storage Access Pattern
```lua
-- ❌ WRONG (hardcoded magic numbers)
local dex = player:getStorageValue(40001) or 0

-- ✅ CORRECT (centralized constants)
local dex = Attributes.get(player, "dexterity")
-- OR for raw access:
local dex = player:getStorageValue(Storages.ATTRIBUTES.DEXTERITY) or 0
```

### Requirement Validation Pattern
```lua
-- ❌ WRONG (manual checks without user feedback)
if player:getStorageValue(40001) < 2 then
    return false
end

-- ✅ CORRECT (API with personalized messages)
local opts = {
    action = "equip",
    subject = itemName
}
if not Attributes.ensureRequirements(player, {dexterity = 2}, opts) then
    return false
end
```

### Module Loading Pattern
```lua
-- Always at the end of new modules:
_G.ModuleName = ModuleName

if GameLog and GameLog.debug then
    GameLog.debug('ModuleName initialized', 'gameplay:module')
end
```

## Important Constraints

1. **No C++ Source Modifications**: All gameplay changes must be in Lua scripts
2. **TFS Event System Only**: Use provided hooks (onMoveItem, onUseWeapon, etc.)
3. **Backward Compatibility**: Existing player data (storages) must remain valid
4. **Migration Strategy**: Incremental (pilot → expand → deprecate old), never "big bang" rewrites
5. **Test Without Automated Tests**: Manual testing only (user requested no automated tests)

## Documentation References

- `docs/roadmap_v2.md` - Strategic modularization plan (11-week timeline)
- `docs/equipment-migration-guide.md` - Equipment system design and implementation plan
- `claudedocs/task-orchestration-plan.md` - Detailed task breakdown (6 Epics, 64 Tasks)
- `claudedocs/implementation-summary-epic1.md` - EPIC 1 completion report with test cases
- `claudedocs/equipment-requirement-hook-solution.md` - Equipment validation technical guide

## Key Insights for Future Sessions

1. **Equipment System Status**: Despite roadmap claiming "Phase 5: Not Started", `equipment.lua` EXISTS with 90+ lines. It's PARTIALLY IMPLEMENTED and needs COMPLETION, not creation from scratch.

2. **Critical Bug Fixed**: Equipment.meetsRequirements() was missing `opts` parameter, causing validation messages to only appear on weapon USE, not EQUIP. This is now fixed.

3. **Parallel Work Opportunities**: Admin commands, logging integration, and player commands can all be developed in parallel (different files, no dependencies).

4. **Code Duplication Priority**: 70% duplication across weapon scripts is the highest-impact technical debt. Equipment system completion unlocks consolidation.

5. **GameLog Everywhere**: All modules, hooks, and commands should use GameLog for debugging. It's already integrated in the module loading chain.

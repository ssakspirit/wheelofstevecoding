# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Minecraft Education Edition world titled "Wheel of Stevecoding (v3.0)" - a Korean educational mini-game collection featuring 6 competitive games with dynamic time controls, cutscene management, and team-based scoring.

## Architecture

### Core Structure
- `behavior_packs/bp0/` - Game logic, entities, functions, and JavaScript scripts
- `resource_packs/rp0/` - Visual assets, models, textures, animations, and UI
- `level.dat` - World data and NBT-encoded settings
- `education.json` - Education Edition specific configuration
- World pack linkage: `world_behavior_packs.json`, `world_resource_packs.json`

### Game Flow System

**Sequence-Based Event System (`functions/seq/`):**
- Acts are organized in folders (`act0/`, `act1/`, etc.)
- Each act contains numbered sequence files (e.g., `001.mcfunction`, `101.mcfunction`)
- Global scoreboards `.act` and `.seq` track current state
- Controlled via `loops/new_act.mcfunction` which resets sequence counters

**Main Loop (`functions/loops/tick.mcfunction`):**
- Runs at 20hz via `tick.json` function tag
- Global timers: `.tick` (1-20) and `.tick10` (1-200) for periodic events
- Handles player registration, team selection, and admin observer management
- Multiplayer/singleplayer detection via `.game_mode global` scoreboard

**Timer System (`entities/timer.bp.e.json`):**
- Custom entity using health-based countdown mechanism
- Damaged once per second with instant_damage effect (loops/tick.mcfunction:15)
- Different component groups for each game (orb, grid, craft, nock, elytra, finale)
- Dynamic time scaling via component groups (50%, 70%, 100%)
  - Base times: 1900 health = ~3 minutes (varies by game)
  - Timer events adjust max health: `rwm:timer_50`, `rwm:timer_70`, etc.

### Mini-Games

Each game in `functions/utility/games/[game_name]/`:
- `game_start.mcfunction` - Initializes game, spawns entities, sets up timers
- `game_reset.mcfunction` - Cleans up entities, resets scoreboards
- Game-specific logic files (scoring, mechanics, randomization)

**Games:**
1. **Orb Ambush** (`orb/`) - Orb collection with enemy entities
2. **Craft Off** (`craft/`) - Crafting puzzle with diagram matching and contraption building
3. **Grid Wars** (`grid/`) - Pattern matching with colored blocks
4. **Nock it Off** (`nock/`) - Archery target game with moving minecarts
5. **Elytra Rumble** (`elytra/`) - Flying game with bomb mechanics
6. **Finale Showdown** (`final/`) - Final boss-style showdown

### Time Control System

Commands available in lobby (`.act global matches 0`):
- `/function time1` - Sets `.time_mode global` to 1 (50% time)
- `/function time2` - Sets `.time_mode global` to 2 (70% time)
- `/function time3` - Sets `.time_mode global` to 0 (100% time, default)

Game start functions check `.time_mode` and trigger appropriate timer events:
- `event entity @e[type=rwm:timer] rwm:timer_time_50`
- `event entity @e[type=rwm:timer] rwm:timer_time_70`

### Team & Scoring System

**Team Selection (`utility/teams/`):**
- Location-based detection in `loops/tick.mcfunction`
- Team scoreboard: `team` (0=none, 1=team1, 2=team2)
- Player counters: `.team1players global`, `.team2players global`
- Admin tag automatically assigns observer status (team=0)

**Scoring:**
- Global win counters: `.team1wins global`, `.team2wins global`
- Display scoreboard: `team_scores` for "§4Team 1" and "§9Team 2"
- Reset via `/function reset` (only in lobby)

### Cutscene & Flow Control

**Skip System:**
- `/function skip` - Available for all players, calls `skip_internal.mcfunction`
- Skips current cutscene but preserves essential initialization logic
- Smart skip: Advances `.seq` counter to bypass cutscene sequences

**Admin Commands:**
- `/function admin` - Grants observer mode (requires admin tag)
- `/function stop` - Ends current game as draw (admin only)
- `/function utility/admin_commands` - Shows current game status

**Game Navigation:**
- `/function reset` - Full reset: clears teams, scores, teleports to team selection (lobby only)
- `/function restart` - Quick restart: teleports to game selection area, preserves teams (lobby only)

### JavaScript API Integration

**Main Script (`behavior_packs/bp0/scripts/Main.js`):**
- Module dependencies: `@minecraft/server` (v1.1.0), `@minecraft/server-ui` (v1.0.0)
- Script event subscription: `system.afterEvents.scriptEventReceive`
- ActionFormData for interactive UI dialogs
- Example implementation for structure loading and time control

**Module Configuration (`manifest.json`):**
```json
{
  "type": "script",
  "language": "javascript",
  "entry": "scripts/Main.js"
}
```

### Entity System

**Naming Convention:**
- Behavior: `[game]_[entity].bp.e.json` (e.g., `craft_part.bp.e.json`)
- Resource: `[game]_[entity].rp.e.json`

**Key Entities:**
- `wheel_of_steve.bp.e.json` - Game selection wheel in lobby
- `timer.bp.e.json` - Universal timer entity with game-specific variants
- `npc_[1-5].bp.e.json` - NPCs with dialogue system (`dialogue/npc.dialogue.json`)
- Game-specific entities with custom animations and particle effects

### Localization

Multi-language support in `behavior_packs/bp0/texts/` and `resource_packs/rp0/texts/`:
- `languages.json` - Language manifest
- Language codes: `ko_KR` (Korean), `en_US` (English), `ja_JP` (Japanese), etc.
- 25+ languages supported

## Common Development Tasks

### Modifying Game Duration

Edit timer entity component groups in `behavior_packs/bp0/entities/timer.bp.e.json`:
```json
"rwm:timer_[game]": {
    "minecraft:health": {
        "value": 1900,  // 1900 = ~3 minutes (damaged 1hp/sec)
        "max": 1900
    }
}
```

For time mode scaling, adjust component groups:
- `rwm:timer_50`: 950 health (50% of base 1900)
- `rwm:timer_70`: 1330 health (70% of base 1900)

### Adding New Sequence Events

1. Create numbered mcfunction file in appropriate `seq/act[N]/` folder
2. Use scoreboard checks: `execute if score .seq global matches [N] run ...`
3. Increment sequence: `scoreboard players add .seq global 1`
4. Transition acts via `function loops/new_act` (resets `.seq` to 0)

### Debugging Game State

In-game commands:
```
/function utility/admin_commands        # Show current act, seq, game state
/scoreboard objectives setdisplay sidebar global  # Display global variables
/scoreboard players list .act           # Check current act number
```

Key scoreboards:
- `.act global` - Current act (0=lobby, 1-6=games)
- `.seq global` - Current sequence within act
- `.game_mode global` - 0=multiplayer, 1=singleplayer
- `.time_mode global` - 0=100%, 1=50%, 2=70%

### Testing Individual Games

Bypass wheel selection by directly calling:
```
/function utility/games/[game_name]/game_start
```

Reset game without returning to lobby:
```
/function utility/games/[game_name]/game_reset
```

### Structure Management

Load game structures:
```
/structure load [structure_name] [x] [y] [z] [rotation] [mode]
```

Ticking area management (required for game chunks):
```
/function utility/tickingarea_add
/function utility/tickingarea_remove
```

## Version Control

Whenever code changes are made, record a one-line description with emoji in Korean in `.commit_message.txt`:
- Read `.commit_message.txt` first, then Edit (overwrite existing content)
- For git revert operations, make `.commit_message.txt` empty
- Example: `🎮 크래프트 게임 타이머 조정 - 4분에서 3분으로 변경`

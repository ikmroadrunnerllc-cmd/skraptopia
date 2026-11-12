# Handoff: JRPG vertical slice

Branch: `jrpg-vertical-slice` (made from `level1-woods`). `main` was not touched.
Godot 4.7.2. Screen: 640×360, scaled up to a 1280×720 window. Camera zoom 2.

## Status: playable, automated playtest passes (52/52)

The whole loop works:
village → talk to Elder → accept "Slime Trouble" → south exit → field → touch slime →
turn-based battle → win → back to the Elder → quest complete (+20 EXP).
Defeat → "Retry battle" or "Return to village". The pause menu (Esc / Tab) has Status, Quests and Resume.

## Controls

| Action | Keyboard | Controller |
|---|---|---|
| Move | WASD / arrow keys | D-pad / left stick |
| Talk / confirm | E, Space, Enter | A |
| Menu, then cancel/back inside it | Esc, Tab | Start |
| Navigate menus | Arrow keys | D-pad |

## Where things are

| Path | What |
|---|---|
| `resources/*.gd` | Data classes: CharacterData, NPCData, DialogueData, EnemyData, QuestData |
| `data/` | The editable `.tres` files: `characters/hero`, `npcs/elder`, `npcs/merchant`, `enemies/slime`, `quests/slime_trouble` |
| `systems/game_state.gd` | Autoload **GameState**: hero HP/MP/EXP, input locks, defeated encounters, pending battle |
| `systems/quest_manager.gd` | Autoload **QuestManager**: quest states NOT_STARTED → ACTIVE → READY_TO_TURN_IN → COMPLETED |
| `systems/scene_manager.gd` | Autoload **SceneManager**: fade, spawn points, start/return from battle |
| `systems/scene_exit.gd` | Area2D. Walking into it changes scene (`target_scene`, `target_spawn`) |
| `ui/dialogue/` | Autoload **Dialogue**: bottom text box, nameplate, typewriter text, choices |
| `ui/hud.tscn` | Autoload **HUD**: quest notifications and the pause menu (`ui/menus/pause_menu.gd`) |
| `ui/components/` | Reusable `ChoiceList` (all menus and choices) and `StatBar` (HP/MP bars) |
| `ui/themes/jrpg_theme.tres` | Shared theme, set project-wide (Project Settings → GUI → Theme) |
| `npcs/npc.tscn` | Reusable NPC: give it an NPCData in the Inspector |
| `enemies/overworld_enemy.tscn` | Reusable map enemy: EnemyData plus a unique `encounter_id` |
| `Scenes/main.tscn` | Village (your `level_root` + player + Elder + Merchant + south exit + spawns `Start` / `FromField`) |
| `Scenes/field/field.tscn` | Field: tree border, path, one slime, north exit, spawn `FromVillage` |
| `Scenes/battle/battle.tscn` | Battle: BATTLE_START → PLAYER_TURN → ACTION_RESOLUTION → ENEMY_TURN → VICTORY/DEFEAT |

## How to add content (no code)

- **New NPC:** duplicate `data/npcs/merchant.tres`, change the name, sprite sheet and lines. Drag
  `npcs/npc.tscn` into a level and set its `data`.
- **New quest:** duplicate `data/quests/slime_trouble.tres`, give it a new `id`, and put it on an NPC's `quest`.
- **New enemy:** duplicate `data/enemies/slime.tres`. Place `enemies/overworld_enemy.tscn` and give it a new `encounter_id`.

## Rules the code follows

- `.tres` templates are never changed at runtime. HP and quest progress live in GameState and QuestManager.
- Movement, talking and the menu all check `GameState.is_locked()`. Dialogue, menu, battle and
  scene changes each hold their own lock.
- Only the closest NPC shows a prompt and responds. A key press that closes a window can't
  also re-open one, because the lock is released 0.15 s later.

## Testing (outside the project, in `../skraptopia_dev_tools/`)

- `playtest.gd`: runs the whole loop and prints PASS/FAIL.
  `Godot_v4.7.2-stable_win64_console.exe --headless --path . --script ../skraptopia_dev_tools/playtest.gd`
  Add `-- shots dir=<folder>` (without `--headless`) to save screenshots.
- `build_data.gd` / `build_scenes.gd`: the generators that made the theme, the data and the scenes.
  **Don't rerun `build_scenes.gd`.** It would add the NPCs to `main.tscn` a second time.
- `screenshots/`: images from the last passing run.

## Known gaps and next steps

- No level-up yet (EXP only adds up). The Skills, Items and Run buttons show greyed out on purpose.
- No confirmation dialog component yet; nothing needs one.
- The UI uses a flat-colour theme (StyleBoxFlat). It could switch to the Ninja Adventure `DialogBox.png` frames.
- No saving or loading.
- Mana Seed tiles have no collision.
- Patterns 98 and 288 point at old cells (from your big-tile change in source 10).
- The installed `dialogue_manager` addon is not used or enabled.

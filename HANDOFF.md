# Handoff: Level 1 build (Toy Box Kingdom)

**Last updated:** Nov 21, 2026 (evening). **Deadline:** Dec 7, 2026 (presentation).
Godot 4.7.2. Screen 640×360, scaled to a 1280×720 window. World camera zoom 2.

## Start here

1. Read `docs/level1_toy_box_kingdom.md`: the story bible plus every settled design decision. It wins over anything else.
2. Read `docs/level1_build_plan.md`: 6 phases, each ending in a gate of checks.
3. Build with the local `skraptopia-gated-build` workflow: plan → safe prep → build → gate (import, run, playtest, screenshot, user tries it) → close.
4. Before touching files: is Godot open? Ask the user to save (Ctrl+S) first, and tell them to click **Reload** afterwards.
5. Ask the user one question at a time, with a recommended answer. They're a beginner, so keep it plain and short.

## Where we are

| Phase | Status | Branch |
|---|---|---|
| 1. Foundations | **done** (user approved) | `phase-1-foundations` |
| 2. Party battle | **done** (user approved) | `phase-2-party-battle` |
| 2b. Enemy groups | **gate-check:** G2b.1–4 passed; G2b.5 (user plays a group fight and says OK) not confirmed yet | `phase-2b-enemy-groups` (current) |
| 2c. Bonus boss Kilnoxx | next: the art is made, the fight isn't built | — |
| 3. RPG systems | next: level-ups, Buttons, shop, items | — |
| 4. Open world | map, rustling bushes, alphabet block puzzle | — |
| 5. Story | cutscenes, clues, boss, notebook → SkrapBook, shrines (save) | — |
| 6. Polish | balance, credits, real art swaps, merge to `main` | — |

**The branches stack:** `main` → `level1-story` (docs) → `phase-1-foundations` (+ `clay-enemies` merged in) → `phase-2-party-battle` → `phase-2b-enemy-groups`. Nothing is pushed or merged to `main` yet.

**Playtest:** 115/115 PASS. Screenshots are in `../skraptopia_dev_tools/screenshots/` (`phase1_*`, `p2_*`, `p2b_*`).

## Next steps

1. **G2b.5:** ask the user to play a group fight. Each F5 run rolls the field Clay Sludge's group again (1–3 enemies, a 1-in-3 chance of fighting it alone); a beaten encounter stays gone until the game restarts. When they say OK, tick G2b.5, set Phase 2b to `done` and commit.
2. **Phase 2c: Kilnoxx** on `phase-2c-kilnoxx` (design in the story doc, gates in the plan):
   - The art is done: `assets/characters/bosses/kilnoxx/{idle,attack,rage,smash}/00-08.png` (256×160, transparent, facing left). Frame `00` is the idle pose in every animation. Attack and smash end on their pose: play them forward, then backward to get back to idle. Build `kilnoxx_frames.tres` from them (`idle` loops; `cast` = attack; `rage`; `smash` for Inferno Wings).
   - `design/` holds the user's 4 original poses (JPG). The user drew Kilnoxx themselves; it's an original patchwork toy dragon. Don't call it or make it look like any existing game's boss.
   - Add `data/enemies/kilnoxx.tres`, the rage phase, Inferno Wings, the Phoenix Feather and a temporary field spot. The battle currently only plays `cast` and `damage`, so the rage and smash animations need hooks in `battle.gd`.
   - Music: the user will make a Suno track for Kilnoxx. `battle.gd` picks the music in `_play_music()`.
3. Start Phase 3 on `phase-3-rpg-systems`:
   - EXP curve, level cap 10, stat growth for both party members, a "Level up!" screen.
   - Skills unlock at levels 3 and 5.
   - Buttons dropped after battles, an inventory, the shop (Glue Stick, Juice Box, Bandage Tape).
   - Turn on the battle's **Items** command, which is greyed out now.
   - Rename `GameState.exp`: it causes the only remaining warning ("shadows built-in function").
   - Fix Zephyrion floating about 10px above the ground in battle (transparent padding under his feet in the photos).

## What exists now (Phases 1–2)

| Path | What |
|---|---|
| `PlayerScene.tscn` + `Scripts/player_scene.gd` | Demari (32×48 sheet, scaled 0.5). After 3 seconds standing still, a 1px breathing bob that keeps the facing. The sheet has no real idle frames. |
| `assets/characters/party/` | `demari/demari_frames.tres` (real art), `casimir/casimir_frames.tres` (Ninja Adventure **Knight** placeholder) |
| `assets/characters/clay_enemies/<id>/` | Team clay photos: `idle/`, `cast/`, `damage/` frames plus `<id>_frames.tres` |
| `data/enemies/` | 10 enemies: 5 base, 4 color versions (hue/sat/bright fields), Zephyrion (`can_run = false`). `slime.tres` is the old sample quest enemy, now using the Clay Sludge frames. |
| `data/skills/`, `data/items/` | 6 `SkillData` (kind: damage/heal/shield/buff/charge) and 3 `ItemData` |
| `data/characters/` | `hero.tres` (Demari), `casimir.tres` |
| `data/npcs/asmara.tres`, `guard.tres` | Placeholders (Ninja Adventure Princess and CamouflageGreen) |
| `resources/shaders/palette_shift.gdshader` | Recolors the clay photos for the harder versions |
| `systems/game_state.gd` | `party`, Demari `hp/mp`, `casimir_hp/mp`, `member()`, `get_hp()`, `set_member_hp()`, `skills_for()` (by level), `restore_party()` |
| `systems/scene_manager.gd` | `start_battle(enemies, encounter_id, backdrop = "woods")`: one `EnemyData` or an array of 1–3. Retry restores both party members' HP and keeps the same group. |
| `Scenes/battle/` | Side-view battle. The `State` enum values are kept (PLAYER_TURN=1, VICTORY=4, DEFEAT=5, TARGETING=6), and `battle.actor` is whose turn it is. `battle.foes` is an array of `{data, hp, label, sprite, name, bar}`. Each member acts, then each living enemy. Attack, Scribble Strike and Wind-Up Charge show a target arrow (left/right, confirm, Esc to cancel); it's skipped when only one enemy is left. `SkillData.hits_all` makes Eraser Blast hit every enemy. Normal fights play `music/battle.ogg`; Zephyrion plays `music/boss_zephyrion.mp3`. |
| `enemies/overworld_enemy.gd` | `group_pool`: the touched enemy brings 0–2 random extras from this list. The field's Clay Sludge uses Clay Sludge + Pipe Spider. |
| `assets/audio/game/` | Only the audio the game uses: `music/`, `sfx/battle`, `sfx/ui`, `sfx/world`, `sfx/voices`, plus `CREDITS.md`. Only the battle music is hooked up so far; the rest goes in during Phase 6. |
| `assets/characters/bosses/kilnoxx/` | Kilnoxx animation frames and the user's design poses (see Phase 2c above). |
| `assets/effects/battle/*.tres` | Battle effects (Ninja Adventure + Super Pixel Effects) |
| `assets/backgrounds/battle_woods.png` | Backdrop made from the map's own tiles. Road, town and tavern backdrops come in Phase 4. |

The village (`Scenes/main.tscn`), field, NPCs, dialogue, quest and pause menu from the older vertical slice still work. Phase 5 replaces the sample "Slime Trouble" quest with the real story.

## Tools

- Godot console: `C:/Users/lolst/Downloads/New folder/Godot_v4.7.2-stable_win64_console.exe`
- Import: `--headless --path . --import` (ignore `super_pixel_*` long-path noise)
- Playtest: `--headless --path . --script ../skraptopia_dev_tools/playtest.gd` (it has `wait_turn(b, id)` and `seed_for(callable)` helpers for battles)
- Screenshots: the same command without `--headless`, plus `-- shots "dir=<folder>"`
- Godot MCP (`run_project`, `get_debug_output`, `stop_project`) for error checks
- **PixelLab MCP** (pixel art and animation). It's in Mario's local Claude settings, so a teammate needs their own key: `claude mcp add pixellab https://api.pixellab.ai/mcp -t http -H "Authorization: Bearer <key>"`. Trial plan: 1 job at a time, about 11 generations left. `animate_image_pixminimax` with a first and last frame up to 256×256, 8 frames = 1 generation, done in about 1 minute. Upload local files with `get_upload_url` plus curl.
- **The dev tools live outside the repo:** `../skraptopia_dev_tools/` (`playtest.gd`, builders, screenshots, `kilnoxx_art/`, `downloads/` with the full sound packs). A teammate on another PC needs Mario to send that folder.
- One-off builder scripts go in the session scratchpad: `extends SceneTree` using `_initialize()`, saved with `ResourceSaver`. They don't write a uid header, so link the result by path.

## Gotchas

- Don't rerun `../skraptopia_dev_tools/build_scenes.gd`: it duplicates the NPCs.
- After any headless scene save, diff the file and restore the `uid=` tags (`main.tscn` must keep `uid://hl1lepnvh0w`).
- Scale pixel characters by integer-friendly amounts (0.5 in the world, 1.5 or 3 in battle).
- No comments in game scripts (team style). No AI mentions in commits, code or docs.
- `OverworldEnemy.group_pool` is a typed `Array[EnemyData]`: clear it with `.clear()`. Assigning `[]` fails.
- Don't put copyrighted music or art in the project. `Downloads/quincy's craft.mp3` (Bleach OST) was only a style reference. The `Yharon (1).png` in the project root is someone else's art: keep it out of git.
- `git pull` or `git reset` can overwrite or delete the gitignored local files (`CLAUDE.md`, `AGENTS.md`, `.claude/`) when a commit tracks them. Copy them aside first.

## Git and team

- `origin/main` has old history again: teammate `jj921` pushed the enemy zip from an old copy, on top of a merge that brought back old commits. Before pushing or cleaning `main`, `jj921` needs to download a fresh copy. Never force-push without the user's yes. There's a full backup bundle at `backups/pre-history-clean-20261111.bundle`.
- Teammates send art to the user (Mario), not to GitHub.
- **Still waiting on art:** the real Princess Asmara sheet (`Documents/Skraptopia Sprites Sheet/Princess Asmara Sprite Sheet.png` is a byte-for-byte copy of Demari's), Casimir art, and optional Demari idle frames.

## Controls

| Action | Keyboard | Controller |
|---|---|---|
| Move | WASD / arrow keys | D-pad / left stick |
| Talk / confirm | E, Space, Enter | A |
| Menu / back | Esc, Tab | Start / B |

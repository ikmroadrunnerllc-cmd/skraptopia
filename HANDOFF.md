# Handoff: Level 1 build (Toy Box Kingdom)

**Last updated:** Nov 22, 2026. **Deadline:** Dec 7, 2026 (presentation).
Godot 4.7.2. Screen 640×360, scaled to a 1280×720 window. World camera zoom 2.
**Everything is local only. Nothing is pushed, by the user's choice.**

## Start here

1. Read `docs/level1_toy_box_kingdom.md`: the story bible plus every settled design decision. It wins over anything else.
2. Read `docs/level1_build_plan.md`: the phases, each ending in a gate of checks.
3. Build with the local `skraptopia-gated-build` workflow: plan → safe prep → build → gate (import, run, playtest, screenshot, user tries it) → close.
4. Before touching files: is Godot open? Ask the user to save (Ctrl+S) first, and tell them to click **Reload** afterwards.
5. Ask the user one question at a time, with a recommended answer. They're a beginner, so keep it plain and short.

## Where we are

| Phase | Status | Branch |
|---|---|---|
| 1. Foundations | **done** | `phase-1-foundations` |
| 2. Party battle | **done** | `phase-2-party-battle` |
| 2b. Enemy groups | **done** (the user played a group fight, Nov 22) | `phase-2b-enemy-groups` |
| 2c. Secret bonus bosses | **building:** art, data, music and test keys are in; the rage phases, specials and drops aren't built yet | `phase-2c-bosses` (current) |
| 2d. Menus and button hints | next | — |
| 3. RPG systems | level-ups, Buttons, shop, items, inventory screens | — |
| 4. Open world | map, rustling bushes, alphabet block puzzle, the 3 boss hiding spots | — |
| 5. Story | cutscenes, clues, boss, notebook → SkrapBook (Paper UI), shrines (save) | — |
| 6. Polish | balance, Controls rebinding, Boss Rush, credits, merge to `main` | — |

**The branches stack:** `main` → `level1-story` → `phase-1-foundations` → `phase-2-party-battle` → `phase-2b-enemy-groups` → `phase-2c-bosses`. Nothing is merged to `main` or pushed.

**Playtest:** 134/134 PASS. Screenshots are in `../skraptopia_dev_tools/screenshots/` (`phase1_*`, `p2_*`, `p2b_*`, `test_<boss>`).

## Testing the fights (debug runs only)

Press F5 in Godot, then in the village or field press:

| Key | Fight |
|---|---|
| F1 | Iron Jaws |
| F2 | Kilnoxx |
| F3 | Captain CrackJack |
| F4 | Zephyrion |
| F6 | A random group of 1–3 of the team's 9 clay monsters |

The keys refill the party first. The party is level 1 and level-ups don't exist yet (Phase 3), so the bonus bosses (tuned for 7–10) win quickly. Use Retry. The keys live in `systems/scene_manager.gd` (`TEST_BOSSES`, `TEST_MONSTERS`) and only work when `OS.is_debug_build()`.

**Demo setup:** the field's Clay Sludge now mixes in all 9 clay monsters (Clay Sludge, Pipe Spider, Paper-Dactyl, Mecha Orc Knight and Lancer, and the 4 color versions) so the demo shows off the team's monsters. Phase 4 gives each monster its real area.

## Next steps

1. **Finish Phase 2c** (`phase-2c-bosses`; full list and gate checks in the plan):
   - The shared rage rule at half HP: rage line, Attack +30%, special every other turn. `battle.gd` plays only `cast` (= attack) and `damage` now; hook up `rage` and `smash`. CrackJack also has a `hover` loop.
   - Specials: Clockwork Frenzy (one target twice), Inferno Wings and Liberty Dash (both). CrackJack takes 30% less damage while raging. Kilnoxx gets a white-gold palette shift.
   - Drops as key items in `GameState`: Steel Fang (+15% damage), Phoenix Feather (once-per-battle revive at half HP), Star Medal (−15% damage taken).
   - A `boss_music_lyrics` setting (default off) that picks `boss_<id>_lyrics.mp3`. `battle.gd` `BOSS_MUSIC` maps boss ids to the instrumentals.
   - Temporary field spots for each boss.
   - Boss stats in `data/enemies/<id>.tres` are a first guess.
2. **Phase 2d:** the Pocket Inventory pause menu (Status, Quests, Settings, Restart, Resume), Settings (boss music, volumes) and automatic keyboard/controller button hints. Read the pack's license PDF first.
3. **Phase 3** as planned. Also rename `GameState.exp` (the only warning) and fix Zephyrion floating about 10px above the ground.

## The bonus bosses

All 3 are the user's own designs, animated with PixelLab: 256×160 frames facing left, `00`–`08` per animation.

| Boss | Id | Animations | Level | Song |
|---|---|---|---|---|
| Iron Jaws (wind-up piranha) | `iron_jaws` | idle, attack, rage, smash | 7 | Fish (Suno) |
| Kilnoxx, the Kiln Phoenix | `kilnoxx` | idle, attack, rage, smash | 9–10 | Japanese taiko (Suno) |
| Captain CrackJack (nutcracker) | `captain_crackjack` | idle, attack, rage (lift-off), hover, smash (dash, played slower) | 8 | Americana (Suno) |

- **SpriteFrames** (`assets/characters/bosses/<id>/<id>_frames.tres`): `idle` loops; `cast`, `rage` and `smash` play forward, then backward to idle. They were written by a Python script, so they have no uid headers.
- **Source art and previews** are in `../skraptopia_dev_tools/`:
  - `fish_boss_art/` and `nutcracker_art/` (GIFs, sheets, the base poses, and CrackJack's old front-facing set in `old_front/`)
  - `kilnoxx_art/`
  - preview pages: `bosses_preview.html` and `kilnoxx_preview.html`
- **The user's original songs** are in `Documents/Scraptopia Muisc bosses/`. Suno named every file "Reloj Maldito"; the folder names say which is which. They were copied in as `assets/audio/game/music/boss_<id>.mp3` and `boss_<id>_lyrics.mp3`. Zephyrion keeps `boss_zephyrion.mp3`.
- An older rock version of the Iron Jaws song is saved in `../skraptopia_dev_tools/music_candidates/fish_boss/` (not used).

## What exists now

| Path | What |
|---|---|
| `PlayerScene.tscn` + `Scripts/player_scene.gd` | Demari (32×48 sheet, scaled 0.5), with a breathing bob when idle. |
| `assets/characters/party/` | `demari/demari_frames.tres` (real art), `casimir/casimir_frames.tres` (Ninja Adventure **Knight** placeholder) |
| `assets/characters/clay_enemies/<id>/` | The team's clay photos: `idle/`, `cast/`, `damage/` plus `<id>_frames.tres` |
| `assets/characters/bosses/<id>/` | The 3 bonus bosses (see above) |
| `data/enemies/` | 13 enemies: 5 base, 4 color versions, Zephyrion, the 3 bonus bosses (all bosses `can_run = false`), plus the old `slime.tres` |
| `data/skills/`, `data/items/`, `data/characters/`, `data/npcs/` | 6 skills, 3 items, Demari and Casimir, and placeholder NPCs |
| `systems/game_state.gd` | Party HP/MP, `member()`, `skills_for()`, `restore_party()` |
| `systems/scene_manager.gd` | `start_battle(enemies, encounter_id, backdrop)` plus the F-key test fights |
| `Scenes/battle/` | Side-view battle with 1–3 enemies, a target arrow, Eraser Blast hitting all, and battle/boss music via the `BOSS_MUSIC` map |
| `enemies/overworld_enemy.gd` | `group_pool`: the touched enemy brings 0–2 random extras |
| `ui/menus/pause_menu.gd` | The current pause menu (Status, Quests, Resume). Phase 2d replaces it. |
| `assets/audio/game/` | The game's audio plus `CREDITS.md` |

## New asset packs (downloaded Nov 21, not in the project yet)

Unpacked copies are in `../skraptopia_dev_tools/downloads/new_ui_2026-11-21/`. The zips are in `Downloads/`.

| Pack | Use | License |
|---|---|---|
| Pocket Inventory #2 (Pixel Map) | Phase 2d menus; puzzle buttons in Phase 4 | Read Me PDF, not checked yet |
| Humble Gift Paper UI | The SkrapBook in Phase 5 | License PDF, not checked yet |
| Retro Inventory (ElvGames) | The item screens in Phase 3 | Free, credit ElvGames |
| 500 Bullets 24×24 | CrackJack's shots in Phase 2c | Not checked yet |
| Kyrise 16×16 RPG Icons (`Documents/Skraptopia Sprites Sheet/`) | Drop icons `necklace_03e` (Steel Fang) and `necklace_02d` (Star Medal) | CC BY 4.0, credit Kyrise |

The menus can also use the Ninja Adventure `assets/ui/ninja_adventure/` set: boxes, keyboard and gamepad button icons, and Yes/No buttons.

## Tools

- Godot console: `C:/Users/lolst/Downloads/New folder/Godot_v4.7.2-stable_win64_console.exe`
- Import: `--headless --path . --import` (ignore `super_pixel_*` long-path noise)
- Playtest: `--headless --path . --script ../skraptopia_dev_tools/playtest.gd`. It has `wait_turn(b, id)` and `seed_for(callable)` helpers. Battles started inside the test chain return to another battle, so use `sm.change_to("res://Scenes/main.tscn")` to get back to the village.
- Screenshots: the same command without `--headless`, plus `-- shots "dir=<folder>"`
- Godot MCP (`run_project`, `get_debug_output`, `stop_project`) for error checks
- **PixelLab MCP:** the trial is **used up** (40/40). A small daily bonus (+5 a night) remains. Its key is in Mario's local Claude settings.
- **The dev tools live outside the repo:** `../skraptopia_dev_tools/`. A teammate on another PC needs Mario to send that folder.
- One-off builder scripts go in the session scratchpad (`extends SceneTree` with `_initialize()`).

## Gotchas

- Don't rerun `../skraptopia_dev_tools/build_scenes.gd`: it duplicates the NPCs.
- After any headless scene save, diff the file and restore the `uid=` tags (`main.tscn` must keep `uid://hl1lepnvh0w`).
- Scale pixel characters by integer-friendly amounts (0.5 in the world, 1.5 or 3 in battle).
- No comments in game scripts (team style). No AI mentions in commits, code or docs.
- `OverworldEnemy.group_pool` is a typed `Array[EnemyData]`: clear it with `.clear()`. Assigning `[]` fails.
- Don't put copyrighted music or art in the project. Keep these out of git: `Yharon (1).png` and the "LookalikeSpriteSheet Yahron" poses (someone else's boss), and `Downloads/quincy's craft.mp3` (Bleach OST, a style reference only).
- The project root has untracked user files: the nutcracker JPGs, `Concept art fish toy boss machine.jpg`, and `Iron Jaws of the Deep` mp3/jpeg. They're source art and songs, already copied where needed. The user can delete them.
- `git pull` or `git reset` can overwrite or delete the gitignored local files (`CLAUDE.md`, `AGENTS.md`, `.claude/`). Copy them aside first.

## Git and team

- `origin/main` has old history again: teammate `jj921` pushed from an old copy. Before pushing or cleaning `main`, `jj921` needs a fresh copy. Never force-push without the user's yes. There's a backup bundle at `backups/pre-history-clean-20261111.bundle`.
- Teammates send art to the user (Mario), not to GitHub.
- **Still waiting on art:** the real Princess Asmara sheet, Casimir art, and optional Demari idle frames.

## Controls

| Action | Keyboard | Controller |
|---|---|---|
| Move | WASD / arrow keys | D-pad / left stick |
| Talk / confirm | E, Space, Enter | A |
| Menu / back | Esc, Tab | Start / B |
| Test fights (debug) | F1–F4, F6 | — |

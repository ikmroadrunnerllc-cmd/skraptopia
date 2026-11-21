# Handoff: Level 1 build (Toy Box Kingdom)

**Last updated:** Nov 21, 2026. **Deadline:** Dec 7, 2026 (presentation).
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
| 2. Party battle | **gate-check:** G2.1–G2.4 passed; waiting for **G2.5, the user playing a battle and saying OK** | `phase-2-party-battle` (current) |
| 3. RPG systems | next: level-ups, Buttons, shop, items | — |
| 4. Open world | map, rustling bushes, alphabet block puzzle | — |
| 5. Story | cutscenes, clues, boss, notebook → SkrapBook, shrines (save) | — |
| 6. Polish | balance, credits, real art swaps, merge to `main` | — |

**The branches stack:** `main` → `level1-story` (docs) → `phase-1-foundations` (+ `clay-enemies` merged in) → `phase-2-party-battle`. Nothing is pushed or merged to `main` yet.

**Playtest:** 90/90 PASS. Screenshots are in `../skraptopia_dev_tools/screenshots/` (`phase1_*`, `p2_*`).

## Next steps

1. Ask the user whether the battle works (G2.5). Fix anything they report, then tick G2.5, set Phase 2 to `done` and commit.
2. Start Phase 3 on `phase-3-rpg-systems`:
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
| `systems/scene_manager.gd` | `start_battle(enemy, encounter_id, backdrop = "woods")`. Retry restores both party members' HP. |
| `Scenes/battle/` | Side-view battle. The `State` enum values are kept (PLAYER_TURN=1, VICTORY=4, DEFEAT=5), and `battle.actor` is whose turn it is. Each member acts, then the enemy. |
| `assets/effects/battle/*.tres` | Battle effects (Ninja Adventure + Super Pixel Effects) |
| `assets/backgrounds/battle_woods.png` | Backdrop made from the map's own tiles. Road, town and tavern backdrops come in Phase 4. |

The village (`Scenes/main.tscn`), field, NPCs, dialogue, quest and pause menu from the older vertical slice still work. Phase 5 replaces the sample "Slime Trouble" quest with the real story.

## Tools

- Godot console: `C:/Users/lolst/Downloads/New folder/Godot_v4.7.2-stable_win64_console.exe`
- Import: `--headless --path . --import` (ignore `super_pixel_*` long-path noise)
- Playtest: `--headless --path . --script ../skraptopia_dev_tools/playtest.gd` (it has `wait_turn(b, id)` and `seed_for(callable)` helpers for battles)
- Screenshots: the same command without `--headless`, plus `-- shots "dir=<folder>"`
- Godot MCP (`run_project`, `get_debug_output`, `stop_project`) for error checks
- One-off builder scripts go in the session scratchpad: `extends SceneTree` using `_initialize()`, saved with `ResourceSaver`. They don't write a uid header, so link the result by path.

## Gotchas

- Don't rerun `../skraptopia_dev_tools/build_scenes.gd`: it duplicates the NPCs.
- After any headless scene save, diff the file and restore the `uid=` tags (`main.tscn` must keep `uid://hl1lepnvh0w`).
- Scale pixel characters by integer-friendly amounts (0.5 in the world, 1.5 or 3 in battle).
- No comments in game scripts (team style). No AI mentions in commits, code or docs.
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

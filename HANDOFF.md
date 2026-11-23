# Handoff: Level 1 build (Toy Box Kingdom)

**Last updated:** Nov 23, 2026. **Deadline:** Dec 7, 2026 (presentation).
Godot 4.7.2. Screen 640×360, scaled to a 1280×720 window. World camera zoom 2.
**`phase-2c-bosses` was pushed to GitHub on Nov 23 at the user's request.** `main` is untouched.

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
| 2b. Enemy groups | **done** | `phase-2b-enemy-groups` |
| 2c. Secret bonus bosses | **mostly done:** art, data, music, test keys, rage phase + specials, lyrics setting. Still open: CrackJack −30% damage while raging, Kilnoxx white-gold palette, the 3 drops, temporary field spots | `phase-2c-bosses` (current) |
| 2d. Menus, button hints, new battle layout | **battle layout done early**; boss-music switch in the pause menu done. Still open: Pocket Inventory restyle, Settings (volumes), Restart, button hints outside battle | — (work so far is on `phase-2c-bosses`) |
| 3. RPG systems | level-ups, Buttons, shop, items, inventory screens | — |
| 4. Open world | map, rustling bushes, alphabet block puzzle, the 3 boss hiding spots, entering buildings | — |
| 5. Story | cutscenes, clues, boss, notebook → SkrapBook (Paper UI), shrines (save) | — |
| 6. Polish | balance, Controls rebinding, Boss Rush, credits, merge to `main` | — |

**The branches stack:** `main` → `level1-story` → `phase-1-foundations` → `phase-2-party-battle` → `phase-2b-enemy-groups` → `phase-2c-bosses`. Nothing is merged to `main` or pushed.

**Playtest:** 171/171 PASS. Screenshots are in `../skraptopia_dev_tools/screenshots/`.

## Done this session (Nov 22, on `phase-2c-bosses`)

- **Boss rage** (`Scenes/battle/battle.gd`, `BOSS_RAGE`): at half HP the boss plays `rage`, the screen shakes, its rage line appears big with shaking letters (RichTextLabel `[shake]`) in its own font and color, then Demari and Casimir quip. After that: Attack +30%, special every other turn (`smash` anim). CrackJack switches to his `hover` loop. Specials: Clockwork Frenzy (one hero twice), Inferno Wings and Liberty Dash (both heroes).
  - Fonts (user's picks, all SIL OFL, license files next to them) in `assets/ui/fonts/bosses/`: New Rocker = Iron Jaws, WDXL Lubrifont TC = Kilnoxx (line is in Japanese on purpose, the party jokes about it), Ewert = CrackJack, Creepster = saved for the ogre cutscene.
  - Quips and fonts are written in the story doc (bonus bosses section).
- **New battle layout** (`Scenes/battle/battle.tscn` `Hud` node + `battle.gd`), matching mockup v3:
  - Front view for clay monster fights **and Zephyrion** (bigger, centered). Party seen from behind (`Walking_Up`): Demari bottom left (scale 2), Casimir bottom right (scale 4). The actor steps up.
  - Side view only for the 3 bonus bosses (`_front = not any foe in BOSS_RAGE`).
  - Slim HUD: message strip at top, Retro Inventory gold bar with portraits, heart HP/MP bars, Kyrise icon commands with the name below, skill list pops up above the bar, E/Esc hints that switch to A/B on controller input. HUD font PixelOperator8 size 8 (sub-theme `Theme_hud`).
  - `ui/components/choice_list.gd` now `extends BoxContainer` (works as a row when `vertical` is false).
  - Art copied in: `assets/ui/retro_inventory/` (credit ElvGames), `assets/ui/kyrise/` (CC BY 4.0, credit Kyrise); licenses in `assets/licenses/`.
- **F7 test key** = Mecha Orc Knight, assumed to be "the ogre" (the user never confirmed; they also once called Zephyrion the ogre). Ask.
- **Pause menu "Boss music: Instrumental/Lyrics"**: `GameState.set_boss_music_lyrics()` saves to `user://settings.cfg`; battle plays `boss_<id>_lyrics.mp3` when on.
- **Milestone 1 deliverables** (outside the repo, `../skraptopia_dev_tools/milestone1/`):
  - `boss_demo.mp4` (1:31, instrumental): the 3 bonus bosses raging, then Zephyrion. Re-record with `../skraptopia_dev_tools/boss_demo.gd` (Movie Maker: `--write-movie out.avi --fixed-fps 30 --script ...`), then convert with ffmpeg. There's no system ffmpeg; a portable one was installed to the session scratchpad via `pip install --target <dir> imageio-ffmpeg` (redo if gone). The demo raises the party's attack/defense only while it runs (level-ups don't exist yet).
  - `SkrapTopia_Milestone1_Update.docx`: credits, checklist status table, 12 captioned screenshots.
  - Credits the user wants: **Jason Appling** made the clay models and animation frames; **Steven Tran** made Demari and Princess Asmara. The team checklist lists Paris for the Zephyrion model; the user said to credit Jason.

## Testing the fights (debug runs only)

Press F5 in Godot, then in the village or field press:

| Key | Fight |
|---|---|
| F1 | Iron Jaws |
| F2 | Kilnoxx |
| F3 | Captain CrackJack |
| F4 | Zephyrion |
| F6 | A random group of 1–3 of the team's 9 clay monsters |
| F7 | Mecha Orc Knight ("the ogre") |

The keys refill the party first. F1–F4 also give the party boss-ready stats (the `boss_demo.gd` values, about level 8) so each boss reaches rage; F6/F7 put the base stats back (`_set_test_stats`). The README has these instructions for the team. The keys live in `systems/scene_manager.gd` (`TEST_BOSSES`, `TEST_MONSTERS`).

## Next steps

1. **Playroom Woods design is settled** (story doc, "Playroom Woods map"): own map per area, 40×30, forest + toys, route bottom to top, village as a side area on the left after the tutorial, Iron Jaws pond with rocks to hop across. Still to ask: anything else about the woods, then extend the Phase 4 plan and build. Proof screenshots for the team checklist are in `../skraptopia_dev_tools/milestone1/proof/` (concept art still missing).
2. **Ogre cutscene** (requested earlier): a dialogue-box cutscene with the ogre before its fight, using the existing `ui/dialogue/dialogue_box.gd` (`play(DialogueData)`). Ogre rage line in Creepster green: *"The ogre roars with rage!"* / Demari *"I think we made it mad."* / Casimir *"You think?!"*. Confirm which enemy is the ogre first.
3. Finish the open 2c items (above) and the rest of 2d.
4. Phase 3 as planned. Also rename `GameState.exp` (the only warning) and fix Zephyrion floating about 10px above the ground.

## The bonus bosses

All 3 are the user's own designs, animated with PixelLab: 256×160 frames facing left, `00`–`08` per animation.

| Boss | Id | Animations | Level | Song |
|---|---|---|---|---|
| Iron Jaws (wind-up piranha) | `iron_jaws` | idle, attack, rage, smash | 7 | Fish (Suno) |
| Kilnoxx, the Kiln Phoenix | `kilnoxx` | idle, attack, rage, smash | 9–10 | Japanese taiko (Suno) |
| Captain CrackJack (nutcracker) | `captain_crackjack` | idle, attack, rage (lift-off), hover, smash | 8 | Americana (Suno) |

- **SpriteFrames** (`assets/characters/bosses/<id>/<id>_frames.tres`): `idle` loops; `cast`, `rage` and `smash` play forward, then backward. No uid headers (written by a script).
- **Source art and previews:** `../skraptopia_dev_tools/` (`fish_boss_art/`, `nutcracker_art/`, `kilnoxx_art/`, `bosses_preview.html`, `kilnoxx_preview.html`).
- **Songs:** `assets/audio/game/music/boss_<id>.mp3` and `boss_<id>_lyrics.mp3`; Zephyrion has only `boss_zephyrion.mp3`. Originals in `Documents/Scraptopia Muisc bosses/`.

## Team art status

- `origin/main` has commit `cbbefcd9` by `jj921` (Nov 20): `SkrapTopia enemy frames (unedited).zip`. Checked without pulling: 112 of its 114 photos are already in the project. The 2 new ones are Pipe Spider "knockout" photos on a black background (could become a KO animation after background removal).
- **Nappin Susa** has idle frames in `assets/characters/clay_enemies/nappin_susa/` but no enemy data; it was cut in the design. Asked the user whether to bring it back (recommended: keep cut). No answer yet.
- **Still waiting on art:** the real Princess Asmara sheet, Casimir art, optional Demari idle frames.

## What exists now

| Path | What |
|---|---|
| `PlayerScene.tscn` + `Scripts/player_scene.gd` | Demari (32×48 sheet, scaled 0.5), with a breathing bob when idle. |
| `assets/characters/party/` | `demari/demari_frames.tres` (real art), `casimir/casimir_frames.tres` (Ninja Adventure **Knight** placeholder) |
| `assets/characters/clay_enemies/<id>/` | The team's clay photos: `idle/`, `cast/`, `damage/` plus `<id>_frames.tres` |
| `assets/characters/bosses/<id>/` | The 3 bonus bosses |
| `data/enemies/` | 13 enemies (5 base, 4 color versions, Zephyrion, 3 bonus bosses; all bosses `can_run = false`) plus the old `slime.tres` |
| `systems/game_state.gd` | Party HP/MP, `member()`, `skills_for()`, `restore_party()`, `boss_music_lyrics` + settings file |
| `systems/scene_manager.gd` | `start_battle(enemies, encounter_id, backdrop)` plus the F-key test fights |
| `Scenes/battle/` | Front/side view battle, slim HUD, 1–3 enemies, target arrow, rage phases, boss music |
| `ui/menus/pause_menu.gd` | Status, Quests, Boss music, Resume. Phase 2d restyles it. |
| `ui/dialogue/dialogue_box.gd` | Dialogue box with nameplate, typing text and choices (use for cutscenes) |

## New asset packs (downloaded Nov 21)

Unpacked copies are in `../skraptopia_dev_tools/downloads/new_ui_2026-11-21/`.

| Pack | Use | License |
|---|---|---|
| Pocket Inventory #2 (Pixel Map) | Phase 2d menus | Read Me PDF, not checked yet |
| Humble Gift Paper UI | The SkrapBook in Phase 5 | License PDF, not checked yet |
| Retro Inventory (ElvGames) | Battle HUD (in use), item screens in Phase 3 | Free, credit ElvGames |
| 500 Bullets 24×24 | CrackJack's shots | Not checked yet |
| Kyrise 16×16 RPG Icons (`Documents/Skraptopia Sprites Sheet/`) | Command icons (in use); drop icons `necklace_03e`, `necklace_02d` | CC BY 4.0, credit Kyrise |

## Tools

- Godot console: `C:/Users/lolst/Downloads/New folder/Godot_v4.7.2-stable_win64_console.exe`
- Import: `--headless --path . --import` (ignore `super_pixel_*` long-path noise)
- Playtest: `--headless --path . --script ../skraptopia_dev_tools/playtest.gd` (wrap in `timeout 500`; a stuck run blocks the shell). Helpers: `wait_turn(b, id)`, `seed_for(callable)`, `rage_checks(b, id)`. Backups of older versions: `playtest.gd.bak_*`.
- Screenshots: the same command without `--headless`, plus `-- shots "dir=<folder>"`
- In tests, raising `max_hp` on the character resources doesn't work (the HP clamp uses the const preload); raise `defense` instead.
- **PixelLab MCP:** trial used up; small daily bonus only.
- **The dev tools live outside the repo:** `../skraptopia_dev_tools/`.
- One-off scripts go in the session scratchpad. Very long heredocs in the Bash tool can fail to parse; use the Edit tool or a script file instead.

## Gotchas

- Don't rerun `../skraptopia_dev_tools/build_scenes.gd`: it duplicates the NPCs.
- After any headless scene save, diff the file and restore the `uid=` tags (`main.tscn` must keep `uid://hl1lepnvh0w`).
- Scale pixel characters by integer-friendly amounts.
- No comments in game scripts (team style). No AI mentions in commits, code or docs.
- `OverworldEnemy.group_pool` is a typed `Array[EnemyData]`: clear it with `.clear()`.
- Don't put copyrighted music or art in the project. Keep `Yharon (1).png` and `Downloads/quincy's craft.mp3` out of git.
- The project root has untracked user files (nutcracker JPGs, fish concept art, Iron Jaws mp3/jpeg). Already copied where needed.
- `git pull` or `git reset` can overwrite or delete the gitignored local files (`CLAUDE.md`, `AGENTS.md`, `.claude/`). Copy them aside first.

## Git and team

- `origin/main` has old history again (teammate `jj921` pushed from an old copy, plus the enemy zip). Before pushing or cleaning `main`, `jj921` needs a fresh copy. Never force-push without the user's yes. Backup bundle: `backups/pre-history-clean-20261111.bundle`.
- Team: Jason Appling (clay models, writing, sound), Steven Tran (character art: Demari, Princess Asmara), Paris Slayton-Hatch (outside help), Mario Gutierrez-Espinal (the user, programming). Teammates send art to Mario, not to GitHub.

## Controls

| Action | Keyboard | Controller |
|---|---|---|
| Move | WASD / arrow keys | D-pad / left stick |
| Talk / confirm | E, Space, Enter | A |
| Menu / back | Esc, Tab | Start / B |
| Test fights (debug) | F1–F4, F6, F7 | — |

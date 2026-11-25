# Handoff: Level 1 build (Toy Box Kingdom)

**Last updated:** Nov 25, 2026. **Deadline:** Dec 7, 2026 (presentation).
Godot 4.7.2. Screen 640×360, scaled to a 1280×720 window. World camera zoom 2.
**Current branch: `phase-3-rpg-systems`** (stacks on `phase-4a-playroom-woods`). Only `phase-2c-bosses` is on GitHub (pushed Nov 23). The user said **not to push** the woods/Phase 3 work yet (Nov 25): ask again before pushing. `main` is untouched.

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
| 2c. Secret bonus bosses | **done** (user said OK Nov 25). Key item drops now built in Phase 3. Small leftovers: CrackJack -30% damage while raging, Kilnoxx white-gold palette | `phase-2c-bosses` (pushed) |
| 2d. Menus, button hints | battle layout + boss-music switch done. Still open: Pocket Inventory restyle, Settings (volumes), Restart, button hints outside battle | - |
| 4a. Playroom Woods | **done** (user said OK Nov 25) | `phase-4a-playroom-woods` |
| 3. RPG systems | **done** (user said OK Nov 25) | `phase-3-rpg-systems` (current) |
| 4. Open world | **next**: Road Carpet, Block Town, block puzzle, Kilnoxx/CrackJack spots | - |
| 5. Story | cutscenes (incl. Princess Asmara, Zephyrion = "the ogre"), clues, notebook -> SkrapBook, shrines | - |
| 6. Polish | balance, Controls rebinding, Boss Rush, credits, merge to `main` | - |

**The branches stack:** `main` -> `level1-story` -> `phase-1-foundations` -> `phase-2-party-battle` -> `phase-2b-enemy-groups` -> `phase-2c-bosses` -> `phase-4a-playroom-woods` -> `phase-3-rpg-systems`.

**Playtest:** 227/227 PASS (backup of the previous version: `playtest.gd.bak_phase3`). Screenshots: `../skraptopia_dev_tools/screenshots/` (`p4a_*` woods, `p3_*` shop, status icons, level-up).

## Done Nov 23-25

- **Playroom Woods** (`Scenes/woods/playroom_woods.tscn`, built by `../skraptopia_dev_tools/build_woods.gd`, safe to rerun): new games start here. Tutorial Clay Sludge, frog-statue shrine spot, 6 rustling bushes that refill after 60 s, hidden gap to Iron Jaws' pond with auto-hop rocks (`systems/stepping_stones.gd`), readable signs (`npcs/signpost.tscn`), left path to the village, top path ends at a "still being built" sign.
- **Phase 3** (all in the story doc and plan):
  - Shared level 1-10 (`GameState.EXP_TABLE`, growth fields on `CharacterData`); `add_exp()` returns the level-up report; `set_level()` / `refresh_stats()`.
  - **Gotcha:** `HERO.max_hp` inside `game_state.gd` is folded to a constant at compile time. Always read stats through `GameState.member(id)`.
  - 6 skills each (new: Ink Splash, Lullaby Doodle, Group Patch, Dent Strike, Cannon Volley, Royal Salute). `SkillData.kind` gained `"status"` and a `status` field.
  - Battle: status effects (poison, sleep, def_down on foes; `buff_turns` = Attack up, `guard_turns` = Defense up for the party) with Ninja Adventure `Skill Icon` icons above whoever has them, RPG Essentials sounds, Items command, Buttons, key item drops + effects (Steel Fang, Star Medal, Phoenix Feather), "Key item!" and "Level up!" pages after Victory.
  - Pause menu: Status shows both heroes + Buttons; new Items page (use items, see key items).
  - `ui/shop/shop.gd` (`Shop.open(host, items)`), opened by any NPC whose `NPCData.sells` is set (the village merchant now sells Glue Stick 15, Juice Box 20, Bandage Tape 60).
- **Decisions:** the ogre is **Zephyrion** (his rage line will use Creepster green). New skills come from level-ups, not chests.
- **Music:** new Kilnoxx songs (instrumental + lyrics) and new Captain CrackJack songs ("Bow to the Iron Nutcracker... Metal Mix", user confirmed it's their own Suno song) are in the game. Iron Jaws unchanged. **Zephyrion still has the old song**; a gritty dark hip-hop prompt was given to the user. The user now has **Suno Pro** (songs made on Pro can be used commercially; older free-plan songs are non-commercial).
## Testing the fights (debug runs only)

Press F5 in Godot, then in the village or field press:

| Key | Fight |
|---|---|
| F1 | Iron Jaws |
| F2 | Kilnoxx |
| F3 | Captain CrackJack |
| F4 | Zephyrion |
| F6 | A random group of 1–3 of the team's 9 clay monsters |
| F7 | Mecha Orc Knight (not the ogre; the ogre is Zephyrion) |

The keys refill the party first. F1-F4 also give the party boss-ready Attack/Defense so each boss reaches rage; F6/F7 put the level's normal stats back (`_set_test_stats` calls `GameState.refresh_stats()`). The README has these instructions for the team. The keys live in `systems/scene_manager.gd` (`TEST_BOSSES`, `TEST_MONSTERS`).

## Next steps

1. **Phase 4: Road Carpet first.** Last open question to the user: what should Road Carpet look like?
   - **A (recommended):** a giant woven rug winding across the forest floor, 40x30 like the woods, toys along the edges (thread spools, a sock, giant buttons), bushes with Pipe Spider / Paper-Dactyl / Magma Sludge, Kilnoxx's scorched clearing behind an easy-to-miss gap ("Turn back. The kiln is lit.").
   - **B:** indoors (giant bedroom floor, furniture legs as trees).
   - **C:** woods on the sides, a carpet road through the middle that widens near town.
   Then: write the decisions into the story doc, extend the Phase 4 plan, build like the woods (a builder script in `../skraptopia_dev_tools/`), connect the woods' top exit.
2. Then **Block Town** (castle, shop with `NPCData.sells`, train station with CrackJack's closed platform, market, tavern, 3 clues, A-B-C-D block puzzle).
3. **Phase 5:** cutscenes (opening, tutorial, castle talk with the guard, tavern + Zephyrion's rage, knighting, ending), Princess Asmara (placeholder sprite until Steven's sheet arrives), notebook -> SkrapBook, shrines.
4. Unanswered: should Captain CrackJack's backstory go in the story doc? (abandoned Christmas nutcracker, memories taken by Yalboa, guards a train platform; late-game twist: the SkrapBook gives his memory back). Recommended yes.
5. Small leftovers: rename `GameState.exp` (warning), Zephyrion floats ~10px above the ground, 2c leftovers, 2d menus.
## The bonus bosses

All 3 are the user's own designs, animated with PixelLab: 256×160 frames facing left, `00`–`08` per animation.

| Boss | Id | Animations | Level | Song |
|---|---|---|---|---|
| Iron Jaws (wind-up piranha) | `iron_jaws` | idle, attack, rage, smash | 7 | Fish (Suno) |
| Kilnoxx, the Kiln Phoenix | `kilnoxx` | idle, attack, rage, smash | 9–10 | Enka rock "The Phonix" (Suno, Nov 25) |
| Captain CrackJack (nutcracker) | `captain_crackjack` | idle, attack, rage (lift-off), hover, smash | 8 | "Bow to the Iron Nutcracker" metal mix (Suno, Nov 25) |

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
| `systems/game_state.gd` | Party HP/MP, level/EXP, Buttons, `inventory`, `key_items`, `use_item()`, `buy()`, `member()`, `skills_for()`, `restore_party()`, `boss_music_lyrics` + settings file |
| `systems/scene_manager.gd` | `start_battle(enemies, encounter_id, backdrop)` plus the F-key test fights |
| `Scenes/battle/` | Front/side view battle, slim HUD, 1–3 enemies, target arrow, rage phases, boss music |
| `ui/menus/pause_menu.gd` | Status, Quests, Boss music, Items, Resume. Phase 2d restyles it. |
| `ui/shop/shop.gd` | Shop window (Retro Inventory frame) |
| `Scenes/woods/` | Playroom Woods (start of the game) |
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
- Stats: read them through `GameState.member(id)`, never `GameState.HERO.x` (const folding). In tests use `gs.set_level(n)`.
- The playtest script can't name autoload-dependent classes like `Shop` (it compiles before autoloads); match by script path instead.
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

# Level 1 build plan

Built with the `skraptopia-gated-build` workflow. Each phase ends in a gate: everything in it must pass, with proof, before the next phase starts. The design is in `level1_toy_box_kingdom.md`.

**Deadline:** Dec 7, 2026 (presentation). Dec 6 is spare time.

| Phase | Dates | What you can see when it's done |
|---|---|---|
| 1. Foundations | Nov 22–23 | Demari walks around as the player; all enemies, skills and items exist as data |
| 2. Party battle | Nov 24–26 | Side-view battle: Demari and Casimir vs. an animated clay enemy, with skills and effects |
| 3. RPG systems | Nov 27–28 | Level-ups, Buttons, shop, items |
| 4. Open world | Nov 29–Dec 1 | The whole kingdom map, with rustling bushes that start fights |
| 5. Story | Dec 2–3 | The full level from opening to ending, plus clues, notebook and shrines |
| 6. Polish | Dec 4–5 | Balanced, credits added, a full start-to-finish playthrough with no problems |

---

## Phase 1: Foundations  (target: Nov 23)  status: done
Goal: the new characters and all the game data are in, so later phases just use them.
Needs: none
Builds:
- Merge the `clay-enemies` branch (the 7 SpriteFrames files).
- Demari's sheet in `assets/characters/party/demari/`, as the player's walk animation in 4 directions.
- Placeholders: Casimir (Knight), Asmara (Princess), guards (CamouflageGreen).
- Enemy data in `data/enemies/` for 6 base enemies + 4 color versions + Zephyrion, with stats, EXP and Buttons.
- Skill and item data (new `SkillData` and `ItemData` resources).
- A color-shift shader for the harder versions.
Gate 1:
- [x] G1.1 Headless import and game run: 0 errors.
- [x] G1.2 Playtest: Demari's animation has 4 directions × 4 frames.
- [x] G1.3 Playtest: all 10 enemy data files load (5 base + 4 color versions + Zephyrion), each with an idle animation.
- [x] G1.4 Screenshot: Demari standing in the village; the 4 color versions side by side.
- [x] G1.5 The user walked Demari around and said OK.

## Phase 2: Party battle  (target: Nov 26)  status: done
Goal: the side-view battle with two party members against a clay enemy.
Needs: Phase 1
Builds:
- Rebuild `Scenes/battle/battle.tscn`: a backdrop, Demari and Casimir on the left (scaled 3×, step forward to act), the enemy on the right playing idle/cast/damage, and a bottom panel with both characters' HP and MP plus the commands.
- Commands: Attack, Skill, Item, Defend, Run (Run is Demari only).
- 6 skills with their effects (see the move→effect table in the story doc).
- Tin Shield (redirect a hit), March Order (Attack up for 3 turns), Wind-Up Charge (charge for a turn, then hit).
- Backdrops rendered from the map tiles. Woods is done; road, town and tavern come in Phase 4, once those areas exist.
- Items command is greyed out until Phase 3 adds the inventory.
Gate 2:
- [x] G2.1 Headless import and run: 0 errors.
- [x] G2.2 Playtest: each of the 6 skills does what its description says (damage, heal, shield, buff, charge).
- [x] G2.3 Playtest: winning and losing both end the battle correctly; Run works on normal enemies and is blocked on the boss.
- [x] G2.4 Screenshot: a battle against the Clay Sludge in the woods.
- [x] G2.5 The user fought a battle and said OK.

## Phase 2b: Enemy groups  (target: Nov 23)  status: done
Goal: fights can have 1–3 enemies at once, and you choose who to hit.
Needs: Phase 2
Builds:
- `battle.gd`/`battle.tscn`: a list of up to 3 enemies on the right, each with its own sprite, name and HP bar. A defeated enemy fades out and is skipped.
- Turn order: Demari, Casimir, then each living enemy in turn.
- A target arrow: after Attack or a damage skill (Scribble Strike, Wind-Up Charge), pick an enemy with left/right and confirm, or press back to cancel. Eraser Blast hits all enemies.
- `SceneManager.start_battle` accepts a list of enemies (a single enemy still works, for the tutorial and the boss).
- A simple area list for now: the field's Clay Sludge starts a random 1–3 group from the Playroom Woods list (Clay Sludge, Pipe Spider). Phase 4 bushes reuse this.
- Victory adds up the EXP of all enemies; Run uses the group (blocked if any enemy can't run).
Gate 2b:
- [x] G2b.1 Headless import and run: 0 errors.
- [x] G2b.2 Playtest: a 3-enemy battle; the target arrow hits the chosen enemy, Eraser Blast hits all of them, every living enemy acts, and you only win when all are down.
- [x] G2b.3 Playtest: a one-enemy battle (the boss) still works, and all older checks still pass.
- [x] G2b.4 Screenshot: a 3-enemy battle in the woods with the target arrow showing.
- [x] G2b.5 The user fought a group battle and said OK.

## Phase 2c: Secret bonus bosses  (target: Nov 25)  status: todo
Goal: three secret, hard boss fights (Iron Jaws, Kilnoxx, Captain CrackJack), each with a rage phase, a special move, a drop and its own music (design in the story doc).
Needs: Phase 2b
Builds:
- Art (already made, in `../skraptopia_dev_tools/`): copy the frames into `assets/characters/bosses/<id>/{idle,attack,rage,smash}/NN.png` and build `<id>_frames.tres` for `iron_jaws`, `kilnoxx` (already in the project) and `captain_crackjack`. Attack and smash play forward, then backward to idle. CrackJack's rage is lift-off then a hover loop.
- `data/enemies/iron_jaws.tres` (level 7), `kilnoxx.tres` (level 9–10), `captain_crackjack.tres` (level 8), all `can_run = false`.
- `battle.gd`: play the `attack`, `rage` and `smash` animations; the shared rage rule at half HP (rage line, Attack +30%, special every other turn); the 3 specials (Clockwork Frenzy, Inferno Wings, Liberty Dash); CrackJack takes 30% less damage while raging; Kilnoxx's white-gold palette shift; CrackJack's shots use the 500 Bullets pack.
- Key items in `GameState`: Steel Fang (+15% damage dealt), Phoenix Feather (once-per-battle revive at half HP), Star Medal (15% less damage taken). They're shown in the inventory in Phase 3.
- Boss music: copy the user's 6 songs into `assets/audio/game/music/` with clear names; the instrumental plays by default. A `boss_music_lyrics` setting (default off) picks the lyrics version; Phase 2d adds the switch to the menu.
- Temporary spots in the current field to start each fight, until Phase 4 builds the real pond, clearing and platform.
Gate 2c:
- [ ] G2c.1 Headless import and run: 0 errors.
- [ ] G2c.2 Playtest: for each boss, the rage starts at half HP (Attack up), and the special is used every other turn with the right targets (Frenzy hits one target twice; Inferno Wings and Liberty Dash hit both).
- [ ] G2c.3 Playtest: CrackJack takes less damage while raging; Steel Fang raises damage dealt; Star Medal lowers damage taken; Phoenix Feather revives the first knock-out at half HP, only once per battle.
- [ ] G2c.4 Playtest: each boss plays its own instrumental, and the lyrics version when the setting is on; Zephyrion still plays his song; older checks still pass.
- [ ] G2c.5 Screenshots: each boss in battle, normal and raging.
- [x] G2c.6 The user fought the bosses and said OK (Nov 25).

## Phase 2d: Menus and button hints  (target: Nov 26)  status: todo
Goal: a nicer pause menu with Settings and Restart, and button hints that match the keyboard or controller.
Needs: Phase 2c
Builds:
- Bring in the Pocket Inventory UI pack (check its license PDF first) and restyle `ui/menus/pause_menu`.
- Pause menu: Status, Quests, Settings, Restart, Resume.
- Settings: boss music (Instrumental or Lyrics), music volume, sound volume; saved to `user://settings.cfg`.
- Restart: an *"Are you sure?"* Yes/No, then it goes back to the last shrine save (for now, the start of the game).
- Button hints that switch between controller and keyboard icons (Ninja Adventure input icons) in the pause menu, dialogue and battle.
- **Done Nov 22 (the user asked for it early):** new battle layout (see the story doc and the v3 mockup): front view for clay monster fights with the party seen from behind; side view kept for bosses; the slim gold HUD (thin message strip, Retro Inventory heart bars, Kyrise icon commands) in every battle.
Gate 2d:
- [ ] G2d.1 Headless import and run: 0 errors.
- [ ] G2d.2 Playtest: changing the boss music and volumes is saved and loaded again; Restart asks first and only restarts on Yes.
- [ ] G2d.3 Playtest: a controller press shows controller icons and a key press shows keyboard icons; older checks still pass.
- [ ] G2d.4 Screenshots: the pause menu and Settings with keyboard and controller hints; a front-view clay fight and a side-view boss fight with the new HUD.
- [ ] G2d.5 The user tried the menu with keyboard and controller and said OK.

## Phase 3: RPG systems  (target: Nov 28)  status: todo
Goal: growing stronger feels good.
Needs: Phase 2
Builds:
- EXP curve and level cap 10; stat growth for Demari and Casimir; shared EXP.
- A "Level up!" screen showing the stat gains and any new skill.
- Skills unlock at levels 1, 3 and 5.
- Buttons (money) dropped after battles; inventory; the shop (Glue Stick, Juice Box, Bandage Tape).
- Items usable in battle and from the pause menu.
- The bonus bosses' Buttons rewards.
- Item and inventory screens in the Retro Inventory style; the 3 key items (Steel Fang, Phoenix Feather, Star Medal) shown with their icons (Kyrise `necklace_03e`, Ninja Adventure feather, Kyrise `necklace_02d`).
Gate 3:
- [ ] G3.1 Headless import and run: 0 errors.
- [ ] G3.2 Playtest: enough EXP gives a level-up with higher stats, and level 3 unlocks Patch Up and March Order.
- [ ] G3.3 Playtest: buying an item spends Buttons, and using it heals the right amount.
- [ ] G3.4 Screenshots: the level-up screen and the shop.
- [ ] G3.5 The user leveled up, shopped, and said OK.

## Phase 4a: Playroom Woods  (target: Nov 24)  status: done
Goal: the first area of the game: a 40×30 forest with toys, where new games start (design in the story doc, "Playroom Woods map").
Needs: Phase 2b
Builds:
- `Scenes/woods/playroom_woods.tscn`, generated by `../skraptopia_dev_tools/build_woods.gd` (safe to rerun): dark-grass forest, dirt path, toys from `toyset_32.png`, invisible `Walls` for the forest and pond, woods music.
- The wake-up spot at the bottom; the Clay Sludge blocks the way into the clearing (tutorial fight, `tutorial_sludge`); the shrine spot (frog statue) in the clearing.
- 6 rustling bushes (Clay Sludge / Pipe Spider, 1–3 enemies) that refill 60 seconds after a win.
- Iron Jaws' fishbowl pond behind a hidden gap on the right: 3 stepping stones you hop across automatically (`systems/stepping_stones.gd`), Iron Jaws on the far shore, and a sign.
- Signs you can read (`npcs/signpost.tscn`); the top path ends at a "still being built" sign until Road Carpet exists.
- The left path leads to the village; the village's south exit leads back to the woods. New games start in the woods.
- `OverworldEnemy`: custom look, rustle, refill timer, and no instant re-fight when you come back from a battle standing on it.
Gate 4a:
- [x] G4a.1 Headless import and run: 0 errors.
- [x] G4a.2 Playtest: start spot, tutorial fight, bushes start fights and refill, hops there and back, Iron Jaws fight, sign, village link (193/193 PASS).
- [x] G4a.3 Screenshots: `../skraptopia_dev_tools/screenshots/p4a_*.png`.
- [x] G4a.4 The user walked the woods and said OK (Nov 25).

## Phase 4: Open world  (target: Dec 1)  status: todo
Goal: the whole kingdom to walk through, with enemies in the bushes.
Needs: Phase 1 (can run alongside Phase 3 if needed)
Builds:
- One connected map: Playroom Woods → Road Carpet → Block Town (castle, shop, train station, market, tavern), with collision, doors and area borders.
- Rustling bushes (pixel art + a shake animation). Touching one starts a battle using that area's enemy list (see the story doc), with a rare chance of a color version.
- Bushes refill after about 60 seconds or when you leave and come back.
- Markers for the story spots (clues, shrines, the tavern, the castle).
- The alphabet block push puzzle in the back alley: blocks A–D slide one tile per push, can't be pushed into walls or other blocks, and the A-B-C-D order opens the alley. A reset spot puts the blocks back.
- Casimir follows Demari around after the tutorial.
- The 3 secret boss spots, each with its sign, replacing the temporary field spots: Iron Jaws' fishbowl pond (Playroom Woods), Kilnoxx's scorched clearing (Road Carpet), Captain CrackJack's closed platform (Block Town train station).
- Puzzle buttons from the Pocket Inventory pack if they fit.
Gate 4:
- [ ] G4.1 Headless import and run: 0 errors.
- [ ] G4.2 Playtest: you can walk from the woods to the tavern door without getting stuck, and you can't walk through buildings or trees.
- [ ] G4.3 Playtest: a bush starts a battle with an enemy from its area's list, then refills.
- [ ] G4.4 Playtest: pushing the blocks into A-B-C-D order opens the alley, a wrong order doesn't, and reset works.
- [ ] G4.5 Screenshots: each of the 4 areas and the puzzle.
- [ ] G4.6 The user explored the map, solved the puzzle and said OK.

## Phase 5: Story  (target: Dec 3)  status: todo
Goal: the whole Level 1 story, playable from start to end.
Needs: Phases 2, 3 and 4
Builds:
- Opening text screens, then Demari wakes up in the woods and finds the notebook.
- Tutorial scene: Casimir vs. the Clay Sludge (the script in the story doc), the tutorial battle, then Casimir joins.
- Castle: talking with Asmara, the guard's interruption, the quest, and starting Buttons.
- Clues 1 and 2 (any order), then clue 3, which unlocks the tavern.
- Tavern: the thief escapes and drops the badge, Zephyrion's dialogue (including the dragon joke), the boss, his last line, and he crumbles into dirt.
- Notebook pages for each new enemy; after the boss, the pages fly into the SkrapBook. Each bonus boss gets its own page. The notebook/SkrapBook uses the Paper UI pack.
- The knighting at the castle, then the ending text screens.
- Shrines: walk up, press confirm, save (and refill HP/MP); load from the title screen.
Gate 5:
- [ ] G5.1 Headless import and run: 0 errors.
- [ ] G5.2 Playtest: the story flags happen in order (tutorial → castle → clues 1 and 2 → clue 3 → boss → knighting → ending).
- [ ] G5.3 Playtest: saving at a shrine and loading brings back level, items, Buttons, clues and notebook.
- [ ] G5.4 Screenshots: each story scene.
- [ ] G5.5 The user played the full story and said OK.

## Phase 6: Polish  (target: Dec 5)  status: todo
Goal: ready to present.
Needs: Phase 5
Builds:
- Balancing (about level 6 by the boss; Zephyrion is beatable but tough).
- Music and sounds (Ninja Adventure audio).
- Controls page in Settings: rebind every action for keyboard and controller (swap on conflict, Reset to default, saved).
- Boss Rush: unlocks after beating all 4 bosses; a pause menu option; all 4 back to back with a refill halfway; no penalty for losing; a SkrapBook trophy and the "Boss Rush Champion" title.
- A credits screen (team roles, plus "Super Pixel Effects by Will Tice / unTied Games", Kyrise icons, ElvGames Retro Inventory, and the other packs' required credits).
- Swap in any real art the team has sent (Asmara, Casimir).
- Merge into `main`, push, and a fresh-download test.
Gate 6:
- [ ] G6.1 A fresh clone imports and runs with 0 errors.
- [ ] G6.2 The full playtest passes from start to finish.
- [ ] G6.3 A full playthrough takes about 30–45 minutes with no softlocks.
- [ ] G6.4 The user (and ideally a teammate) played it start to finish and said OK.

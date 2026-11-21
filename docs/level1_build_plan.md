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

## Phase 2b: Enemy groups  (target: Nov 23)  status: todo
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
- [ ] G2b.1 Headless import and run: 0 errors.
- [ ] G2b.2 Playtest: a 3-enemy battle; the target arrow hits the chosen enemy, Eraser Blast hits all of them, every living enemy acts, and you only win when all are down.
- [ ] G2b.3 Playtest: a one-enemy battle (the boss) still works, and all older checks still pass.
- [ ] G2b.4 Screenshot: a 3-enemy battle in the woods with the target arrow showing.
- [ ] G2b.5 The user fought a group battle and said OK.

## Phase 2c: Bonus boss Kilnoxx  (target: Nov 25)  status: todo
Goal: a secret, very hard fire dragon-phoenix fight with a rage phase (design in the story doc).
Needs: Phase 2b
Builds:
- PixelLab art: one large side-view picture facing left, an idle wing-flap and an attack animation, as `assets/characters/bosses/kilnoxx/kilnoxx_frames.tres`.
- `data/enemies/kilnoxx.tres`: tuned for level 9-10, `can_run = false`.
- Rage phase at half HP: message, white-gold palette shift, Attack +30%, Inferno Wings (hits both party members) every other turn.
- Phoenix Feather: a permanent key item; once per battle it revives the first knocked-out ally at half HP.
- His own music track (from the user's Suno song) when he's in the fight.
- A temporary scorched spot in the field to start the fight until Phase 4 builds the real clearing.
Gate 2c:
- [ ] G2c.1 Headless import and run: 0 errors.
- [ ] G2c.2 Playtest: at half HP the rage starts (color, Attack up), and Inferno Wings hits both party members every other turn.
- [ ] G2c.3 Playtest: with the Phoenix Feather, the first knock-out in a battle revives at half HP, and only once.
- [ ] G2c.4 Screenshot: Kilnoxx in battle, normal and raging.
- [ ] G2c.5 The user fought Kilnoxx and said OK.

## Phase 3: RPG systems  (target: Nov 28)  status: todo
Goal: growing stronger feels good.
Needs: Phase 2
Builds:
- EXP curve and level cap 10; stat growth for Demari and Casimir; shared EXP.
- A "Level up!" screen showing the stat gains and any new skill.
- Skills unlock at levels 1, 3 and 5.
- Buttons (money) dropped after battles; inventory; the shop (Glue Stick, Juice Box, Bandage Tape).
- Items usable in battle and from the pause menu.
- Kilnoxx's Buttons reward.
Gate 3:
- [ ] G3.1 Headless import and run: 0 errors.
- [ ] G3.2 Playtest: enough EXP gives a level-up with higher stats, and level 3 unlocks Patch Up and March Order.
- [ ] G3.3 Playtest: buying an item spends Buttons, and using it heals the right amount.
- [ ] G3.4 Screenshots: the level-up screen and the shop.
- [ ] G3.5 The user leveled up, shopped, and said OK.

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
- Kilnoxx's hidden scorched clearing in Road Carpet, with the burnt warning sign; it replaces the temporary field spot.
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
- Notebook pages for each new enemy; after the boss, the pages fly into the SkrapBook. Kilnoxx gets his own page.
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
- A credits screen (team roles, plus "Super Pixel Effects by Will Tice / unTied Games").
- Swap in any real art the team has sent (Asmara, Casimir).
- Merge into `main`, push, and a fresh-download test.
Gate 6:
- [ ] G6.1 A fresh clone imports and runs with 0 errors.
- [ ] G6.2 The full playtest passes from start to finish.
- [ ] G6.3 A full playthrough takes about 30–45 minutes with no softlocks.
- [ ] G6.4 The user (and ideally a teammate) played it start to finish and said OK.

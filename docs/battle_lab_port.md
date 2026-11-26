# Battle Lab port plan

Bring the systems from `Documents/SkraptopiaBattleLab` into SkrapTopia's real battle (`Scenes/battle/battle.gd`).
Built with the `skraptopia-gated-build` workflow, one branch per phase, starting from `battle-hud`.

## Decisions (settled 2026-11-26)

- **Order:** Asmara joins → threat + enemy AI → Steal/Inspect + Monster Atlas → jobs/sub-job/passives + party menu → assist options → timing check + camera.
- **Asmara** is in the battle party **from the start of Level 1** (Ninja Adventure `Princess` placeholder). The Chapter 2 "meet Asmara" scene must be changed to match.
- **Jobs add skills; they don't replace them.** Demari keeps Doodle Casting, Casimir keeps his charge and shield, and Asmara keeps her own skills. Jobs and sub-jobs add skills and passives on top.
- **Battle Lab goes before** Chapter 2 and Doodle Gate B.
- **Port into SkrapTopia's battle, don't swap it out.** Extend `SkillData`, `CharacterData`, `EnemyData` and `systems/game_state.gd`. Don't add the lab's parallel `Skill`, `PartyMember`, `Monster` or `GameState`.
- **Style:** snake_case and no comments in game scripts. Lab code is rewritten to match.

## Deadline risk

Chapters 2–4 are still open, and the deadline is Dec 7. B0–B2 are the core. **B4 and B5 are the first to cut** if the story falls behind.

---

## Phase B0: Asmara joins the party  (target: Nov 27)  status: done
Goal: Asmara fights next to Demari and Casimir in every battle, with her own skills.
Needs: none (branch `phase-b0-asmara` off `battle-hud`)
Builds:
- `data/characters/asmara.tres`: her `CharacterData`, with stats from the lab's cleric job.
- `data/skills/`: her skills as `SkillData` with `user = asmara`: Royal Mend (heal), Spark Wand (fire), Crown Light (group heal, level 5). Bless was dropped, because the battle only has party-wide buffs and Casimir's March Order already covers that.
- `systems/game_state.gd`: Asmara added to the party (HP/MP, levels, save).
- `Scenes/battle/battle.gd`: a third place in the side and front layouts, a third HUD card, her turn in the speed order, and the turn strip.
- Ninja Adventure `Princess` battle `SpriteFrames` (idle, attack, cast, hurt, KO).
- `docs/level1_toy_box_kingdom.md`: note that she's in the party from the start, and that the Ch2 scene needs adjusting.
Gate B0:
- [x] G B0.1 No errors on import or a game run - how: headless import + MCP run
- [x] G B0.2 Asmara has a turn, her skills work, and the 282 old checks still pass - how: playtest
- [x] G B0.3 Three fighters and three cards fit at 640×360 with nothing overlapping - how: screenshot
- [x] G B0.4 The user played a fight with all three and said OK

## Phase B1: Threat + enemy AI rules  (target: Nov 28)  status: done
Goal: monsters go after whoever annoyed them most, and bosses follow simple rules instead of picking at random.
Needs: B0 done
Builds:
- `systems/threat_table.gd`: per-monster threat from damage, healing, taunts and low HP, with decay each round.
- `resources/ai_rule.gd` + `resources/ai_condition.gd`: priority and weight rules with conditions (HP below %, every N turns, random %, ally down...).
- `resources/enemy_data.gd`: an `ai_rules` list (empty means it attacks its top-threat target).
- `Scenes/battle/battle.gd`: `_foe_attacks` picks targets from threat and rules. Boss rage and Casimir's shield block keep working.
- Rules for 2–3 existing enemies (`.tres`).
Gate B1:
- [x] G B1.1 No errors on import or a game run
- [x] G B1.2 Whoever deals the most damage gets targeted most, healing adds threat, the rules fire, and all old checks pass - how: playtest
- [x] G B1.3 Threat bars are visible on the party cards - how: screenshot
- [x] G B1.4 The user played it and said OK

## Phase B2: Steal / Inspect + Monster Atlas (the notebook)  (target: Nov 29)  status: done (user said "ok", then asked to move on to the story)
Goal: two new battle commands, plus a journal of every monster you've met.
Needs: B1 done
Builds:
- `resources/enemy_data.gd`: `description`, `drops`, `steal_item`, `steal_chance`.
- `Scenes/battle/battle.gd`: Steal and Inspect as Asmara's 0 MP skills (user's choice). Item drops are rolled on a win.
- `systems/game_state.gd`: atlas entries (seen, defeated count, drops known, steal known, fully inspected). They are kept in memory: the game has no save system yet, so they get saved once shrine saves exist.
- The atlas *is* Demari's notebook from the story: a "Notebook" entry in the pause menu, unlocked by the notebook pickup.
Gate B2:
- [x] G B2.1 No errors on import or a game run
- [x] G B2.2 Steal gives the item (once, and it can miss), Inspect fills the entry, a win counts and rolls drops, and all old checks pass - how: playtest
- [x] G B2.3 Atlas page - how: screenshot
- [x] G B2.4 The user played it and said OK

## Phase B3: Jobs, sub-job and passives + party menu  (moved to after Level 1, Dec 4+)  status: todo
Goal: each fighter picks a main job and a sub-job that add skills, and equips passives within 10 PP.
Needs: B2 done
Builds:
- `resources/job_data.gd`, `resources/passive_data.gd`, plus `data/jobs/` (knight, mage, cleric, thief) and `data/passives/` (11).
- `resources/character_data.gd`: main job, sub-job, equipped passives.
- Battle skill list = own skills + job skills. Passives change stats, threat %, heal % and steal chance.
- Party menu (job, sub-job, passives) in the pause menu.
Gate B3:
- [ ] G B3.1 No errors on import or a game run
- [ ] G B3.2 Job skills show up, the PP limit is enforced, passives change the numbers, and all old checks pass - how: playtest
- [ ] G B3.3 Party menu - how: screenshot
- [ ] G B3.4 The user played it and said OK

## Phase B4: Assist options  (moved to after Level 1)  status: todo
Goal: settings for easier enemies, reward multipliers, the timing window and auto-timing.
Needs: B3 done
Gate: no errors, playtest checks that the settings change the numbers and are saved, a screenshot, and the user's OK.

## Phase B5: Timing check + camera  (moved to after Level 1)  status: todo
Goal: a timing press on some skills for bonus damage, plus Phantom Camera framing on hits.
Needs: B4 done (or B3 if B4 is cut)
Gate: no errors, playtest checks that the auto-timing path works, a screenshot, and the user's OK.

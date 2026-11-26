# SkrapTopia: Level 1, Toy Box Kingdom

This is the story bible for Level 1. Everything we build for this level (maps, dialogue, battles, cutscenes) follows it.

## Rules

1. **This file is the source of truth.** If an older doc (the narrative doc, the walkthrough, the video script) disagrees with it, this file wins. If the team changes the story, update this file first, then the game.
2. **The newest group doc wins.** The "Universal Dramatic Level 1 Design Doc" is the newest group document. The other docs fill in details it doesn't cover.
3. **Turn the game into story.** This comes from the template in *The Ultimate Guide to Video Game Writing and Design* (Flint Dille & John Zuur Platten). Every fight, map and item should push the plot forward or reveal a character. If something has no story reason, ask why it's there.
4. **Not every category has to be filled in.** The template lists things to *think about* for each level. Some categories overlap and some stay empty.
5. **Scope: one level.** The finished project is a demo with only the Toy Box Kingdom. Anything for later kingdoms is setup only.
6. **Open questions are listed at the bottom.** Don't guess on those in the game. Settle them with the team, then move the answer up into the doc.

## Team

| Name | Role |
|---|---|
| Jason Appling | Scenario Writer, Character Writer, Programmer |
| Steven Tran | Character Artist, Environmental Artist |
| Mario Gutierrez Espinal | Co-Scenario Writer |
| Paris Slayton-Hatch | Co-Scenario Writer, Character Writer |

## The pitch

*SkrapTopia* is a turn-based RPG. Demari, an average, reclusive undergrad student, gets hold of a rare game rumored to be cursed. When they try to play it, they get trapped inside.

In SkrapTopia everything and everyone is made of scrap: grassy plains of construction paper, seas of clay, people built from yarn, wood or toys.

## Dramatic template

| Category | Level 1 |
|---|---|
| **Level title** | Toy Box Kingdom |
| **Grabber** | Demari gets trapped in the game world. |
| **Bump** | The sacred item, the **SkrapBook**, is stolen from Asmara's castle chambers. |
| **Climax** | Fighting the dirt clay dragon **Zephyrion** and taking back the SkrapBook. |
| **Resolution** | Princess Asmara makes Demari her knight and grants them passage to the next kingdom. |
| **Grand conflict** | Travel to the Arts n' Krafts Witch's castle and defeat the witch to escape the game world. |
| **Immediate conflict** | Find the thief who stole the SkrapBook and return it to Asmara. That earns Demari passage to the next kingdom. |
| **Solution** | Locate the thief and get the sacred item back. |
| **How the player learns the grand conflict** | Casimir escorts Demari to Asmara's castle. Once Asmara hears Demari's situation, she explains it. |
| **How the player learns the immediate conflict** | A guard tells Asmara about the theft while she and Demari are talking about getting to the next kingdom. |
| **Mood / tone** | **Urgent:** find the thief before they escape. **Whimsical:** bright and colorful. **Sinister:** some citizens are odd. |
| **Time of day / weather** | Middle of the day, clear skies. |
| **Initial intention** | Seeking information. Demari has no idea where they are and heads to the Toy Box Kingdom hoping someone can help. |
| **Payoff from a previous level** | None. This is the first level. |
| **Setup for a future level** | To be determined. |
| **Bridging out** | The level ends with Demari leaving the Toy Box Kingdom with Casimir. |

### Location: what's unique about the Toy Box Kingdom

- **Military:** army-style action figures, "The Royal Toy Battalion".
- **Highly integrated:** the most diverse population of all the kingdoms, with citizens of many different races.
- **Public transportation:** a toy train, like the one that runs around a Christmas tree.
- **Floors:** "Road Carpet".
- **Matching elements (repeating symbols):** colorful buildings, toy-like structures and monuments, toy-like characters.
- **Sub-regions** (from the walkthrough): Block Town, Playroom Woods, Witch's Workshop.

### Value system

Money · Magic · Status · Knowledge/intelligence · Memories · Mental stability

### Other realities existing at the same time

- SkrapTopia is a game with supernatural properties: a whole separate world exists inside it.
- It traps the souls (consciousness) of the people who play it.
- Time flows faster in SkrapTopia than in the real world.
- Magic is real.
- People's bodies are objects.

## Characters

| Character | What they are | Arc in Level 1 |
|---|---|---|
| **Demari** (player, they/them) | Undergrad student trapped in the game | Starts scared and confused. Ends self-assured, named Asmara's knight, and the user of the SkrapBook. |
| **Casimir** | Tin soldier, Asmara's royal attendant | Little change. Becomes slightly more trusting of Demari and used to them. Leaves the kingdom with Demari at the end. |
| **Princess Asmara** | Doll, ruler of the Toy Box Kingdom | Grows more confident in her plan against the witch once she finds out Demari can use the SkrapBook. Sees Demari as a pawn and a tool. |
| **Zephyrion** | Dirt clay dragon, hired help, level boss | Is defeated and doesn't change ("dies as he was"). He's a character, not just a boss: he took the job for a commission because he needs money and stability, and he should get a convincing argument for his side. |
| **The thief ("Person A")** | Disguises themselves as a palace guard | Steals the SkrapBook and hands it to Zephyrion. |
| **The Arts n' Krafts Witch** | Main villain, lives in a castle in the far south | Doesn't appear in this level, but their influence is felt through characters' dialogue. Uses memory-manipulation magic. |

## Enemies

| Enemy | Role | Art in the project |
|---|---|---|
| Clay Sludge | Tutorial fight (attacking Casimir) | `assets/characters/clay_enemies/clay_sludge` |
| Pipe Spiders | Regular enemy | `.../pipe_spider` |
| Paper-Dactyl | Regular enemy | `.../paper_terodactyl` |
| Mecha Orc | Regular enemy | `.../mecha_orc_knight`, `.../mecha_orc_lancer` |
| Amfurrbians | Regular enemy | No art yet |
| **Zephyrion**, the dirt clay dragon | **Level boss** | `.../zephyrion` |
| Nappin Susa | Not in the design doc | `.../nappin_susa` (idle only) |

## Lore

- SkrapTopia is an extremely rare game, rumored to be cursed.
- **Sacred Items** are a collection of powerful magic tools made long ago by a great sorcerer.
- The **SkrapBook** is one of them. It can keep any and all of its user's memories, and only certain people can use it. It works in perfect opposition to the witch's memory-manipulation magic, which has always stood in the way of everyone trying to escape SkrapTopia.
- The witch's castle is in the far south of SkrapTopia. To reach it, Demari has to pass through several kingdoms (Paper, Cloth, Scrap Metal), and travel between kingdoms is hard.
- Asmara hoped to reverse-engineer the SkrapBook for her own use.

## Plot, beat by beat

1. **Cutscene:** Demari gets the game, loads it on their PC and is pulled inside.
2. Demari wakes up near the Toy Box Kingdom, sees a big castle in the distance, and heads toward it.
3. On the way, Demari finds Casimir being attacked by a Clay Sludge. **Tutorial battle.**
4. Casimir thanks Demari and takes them to Princess Asmara.
5. Demari explains their situation. Asmara says the only way out is to defeat the Arts n' Krafts Witch, whose castle is far south, past several kingdoms.
6. **Bump:** a guard rushes in. The SkrapBook has been stolen.
7. Asmara's deal: bring back the SkrapBook and she'll guarantee Demari passage to the next kingdom (and resources).
8. **Investigation:** Demari and Casimir follow messages the thief left around the kingdom.
9. They find the meeting place (the tavern) and catch the thief handing the SkrapBook to Zephyrion.
10. Zephyrion causes a scene so the thief can slip away into the kingdom. He plans to fly off outside the kingdom with the book. **Boss battle.**
11. **Reversal:** Demari gets the SkrapBook back, and it turns out Demari can actually use it. Nobody could before. Asmara is surprised.
12. **Resolution:** Asmara makes Demari her personal knight (to keep the SkrapBook's user close for her war on the witch) and grants passage.
13. **Bridging out:** Demari leaves the Toy Box Kingdom with Casimir.

### How the theft worked (3 people)

1. **Person A** disguises themselves as a palace guard, swaps shifts with a real guard, steals the SkrapBook, then announces it's been stolen. In the panic, they slip out of the castle.
2. **Person B** (the Clay Sludge) ambushes Casimir while he's on an errand for Asmara, to keep him busy. The player later learns this attack was part of the plan.
3. Person A lies low in a crowded area and leaves **messages around the kingdom** telling Zephyrion where to meet. **The player uses these messages as clues.**
4. Person A meets Zephyrion to hand over the SkrapBook so he can take it to the witch. The player catches them mid-meetup, which starts the boss battle.

## Opening scene script (from the project update video)

> **Casimir:** Move, you nasty blob of sludge, I MUST get to the princess!!
> **Clay Sludge:** Not a chance, you dweeb!
> *The Clay Sludge attacks and injures Casimir.*
> **Casimir:** Oh goodness, great heavens! My arm! I mean, fin!
> **Clay Sludge:** HAHAHAHA!
> **Demari:** STOP! Stop attacking him right now!
> **Clay Sludge:** Or what?
> **Demari:** Or I'll fight you!
> *Battle.*
> **Casimir:** Thank you for saving me! Are you traveling by yourself?
> **Demari:** Not exactly... I need help. I don't know where I am. And this place is strange.
> **Casimir:** Come with me and I'll take you to Princess Asmara. She'll be able to help you.
> **Demari:** Oh, thank you!
> **Casimir:** It's the least I can do for you saving me.

## Decisions (settled 2026-11-21)

These override anything above that disagrees with them. Deadline: **about Dec 7, 2026**.

### Story

- The witch is **Yalboa, the Arts n' Krafts Witch** (he/him). He doesn't appear in Level 1.
- **Zephyrion** keeps his clay model (a multi-eyed clay creature) and the title "the Dirt Clay Dragon". The joke: *"You don't look much like a dragon." / "Commissions don't pay for wings."*
- Casimir is a **tin soldier**. His opening line becomes *"Oh goodness, great heavens! My arm! My freshly polished arm!"*
- The tutorial enemy is the **Clay Sludge**, and it is **Person B**. A clue reveals this.
- **The thief (Person A)** escapes while Zephyrion causes a scene, and drops a **Yalboa sewing-needle badge**. Their identity stays a mystery for later levels.
- **Zephyrion crumbles into dirt** after his last line: *"You think I wanted this? Clay doesn't pay rent, kid..."*
- **Clues**, all in Block Town. Clues 1 and 2 can be found in any order; clue 3 appears only after both:
  1. Toy train station bench: a torn guard's uniform. *"Someone swapped shifts with a palace guard..."*
  2. Market wall note: *"Sludge kept the tin soldier busy..."*
  3. Barrel behind the tavern: *"Meet at the tavern when the bells ring. Bring the book."* This unlocks the tavern boss.
- **Puzzle (the only one in Level 1):** the thief blocked the back alley to clue 3 with toy **alphabet blocks** (Ninja Adventure Logic tiles A–D). Push them into A-B-C-D order to open the alley. Clue 2's note hints at it ("...easy as A, B, C..."). Extra if there's time: colored key gates.
- **Opening (settled 2026-11-25, kept simple on purpose):** a title screen ("SkrapTopia", New Game; Continue appears once shrines exist), then 3 text screens, each faded in and waiting for confirm:
  1. *"Demari found a strange old game at a little game shop. It was called SkrapTopia."*
  2. *"Back home, Demari pressed Start. The screen flashed... and pulled them right inside!"*
  3. *"Demari woke up in a forest made of paper and toys. A plain notebook lay in the grass nearby."*
  Then the woods. This replaces "loads it on their PC" in beat 1: Demari buys the game at a game shop.
- **Notebook → SkrapBook:** Demari finds a plain notebook at the start and adds a page for each new enemy. After Zephyrion, the pages fly into the SkrapBook, and that's the reversal (Demari can use it).

### What's playable

- **Playable:** the tutorial fight (Playroom Woods), the castle talk with the guard's interruption, the Block Town investigation (3 clues), the tavern boss, and the knighting at the castle.
- **Text screens:** the opening (getting the cursed game) and the ending (leaving with Casimir).
- **Cut:** the moving toy train, the SkrapBook as a battle item, Amfurrbians, Nappin Susa, and the Witch's Workshop.

### World

- **One open-world map:** Playroom Woods → Road Carpet → Block Town (castle, shop, train station, market, tavern).
- **Enemies hide in rustling bushes** (pixel-art bushes). Touching a bush starts the battle. Bushes **refill** after a while; story fights happen once.

| Area | Enemies | Rough level |
|---|---|---|
| Playroom Woods | Clay Sludge, Pipe Spider | 1-2 |
| Road Carpet | Pipe Spider, Paper-Dactyl, Magma Sludge | 2-4 |
| Block Town outskirts | Paper-Dactyl, Mecha Orc Knight, Mecha Orc Lancer, Frost Spider, Ink-Dactyl, Gold Orc Knight (rare) | 4-6 |
| Tavern | **Zephyrion** (boss, tuned for ~level 6) | 6 |

- **Harder color versions** (color-shifted clay photos, about 1.5× stats, more EXP and Buttons, their own notebook page): Magma Sludge (red/orange), Frost Spider (icy blue), Ink-Dactyl (black/purple), Gold Orc Knight (gold, rare).
- **Secret bonus bosses (settled 2026-11-22).** Three optional bosses, not part of the story, one hidden in each area of Level 1. All are the user's own designs, animated with PixelLab (256×160 frames facing left: `idle`, `attack`, `rage`, `smash`). The same picture, smaller, waits in the overworld. They can be fought any time, even early. Run is blocked. Losing gives the normal Retry / Return to village with no penalty. Each gives big EXP and Buttons, its own notebook page and a permanent key item.
  - **Shared rage rule:** at half HP the boss shows its rage line, gets Attack +30%, and uses its special every other turn.

  | | **Iron Jaws** | **Kilnoxx, the Kiln Phoenix** | **Captain CrackJack** |
  |---|---|---|---|
  | What | A wind-up clockwork piranha with a pig snout | A patchwork clay dragon-phoenix that went through the kiln | A red, white and blue nutcracker soldier with jets and an arm cannon |
  | Where | A toy fishbowl pond in **Playroom Woods**, behind bushes. Sign: *"Something is ticking under the water..."* | A scorched clearing in **Road Carpet**, behind an easy-to-miss gap in the trees. Sign: *"Turn back. The kiln is lit."* | A closed platform at the **Block Town** train station (not the clue-1 bench). Sign: *"Platform closed by order of the Captain."* |
  | Tuned for | level 7 | level 9–10 | level 8 |
  | Normal attack | Chomp (one target) | Fire attack (one target) | Arm Cannon (one target) |
  | Rage line | *"Its spring winds tighter!"* (red eye flashes) | *「我が羽よ、燃え上がれ！」* ("My feathers, burst into flame!", in Japanese on purpose; turns white-gold, palette shader) | *"He blasts off into the air!"* (hovers; takes 30% less damage while raging) |
  | Special | **Clockwork Frenzy:** bites one target twice | **Inferno Wings:** hits both party members | **Liberty Dash:** hits both party members |
  | Drop | **Steel Fang:** the party deals +15% damage | **Phoenix Feather:** once per battle, revives the first knocked-out ally at half HP (*"The Phoenix Feather glows!"*) | **Star Medal:** the party takes 15% less damage |
  | Icon | Kyrise `necklace_03e` | Ninja Adventure `Resource/feather.png` | Kyrise `necklace_02d` |

  - **Rage moment (settled 2026-11-22):** the rage line appears big in the middle of the screen with shaking letters, in each boss's own font and color (Iron Jaws: New Rocker, steel blue; Kilnoxx: WDXL Lubrifont TC, fire orange; CrackJack: Ewert, red). The screen shakes on rage and on each special. Then the party quips:
    - Iron Jaws: Demari *"A wind-up fish... with anger issues."* / Casimir *"Who keeps winding that thing?!"*
    - Kilnoxx: Demari *"...Does anyone here speak Japanese?"* / Casimir *"No, but I'm pretty sure it means 'run.'"*
    - CrackJack: Demari *"Since when do nutcrackers FLY?!"* / Casimir *"Since when do they have cannons?!"*
    - The ogre is **Zephyrion** (the clay boss; settled 2026-11-25). His rage uses Creepster, green: *"The ogre roars with rage!"* / Demari *"I think we made it mad."* / Casimir *"You think?!"*
    - Fonts are in `assets/ui/fonts/bosses/` with their SIL Open Font License files; credit them in the game credits.
  - **Boss music:** each bonus boss has the user's own Suno song in two versions. The **instrumental** plays by default; Settings can switch boss fights to the **lyrics** versions. Zephyrion keeps "Clay Doesn't Pay" (one version only).
  - **Boss Rush** (Phase 6): unlocks after beating all 4 bosses (Zephyrion, Iron Jaws, Kilnoxx, Captain CrackJack). A Boss Rush option appears in the pause menu: all 4 back to back, HP and MP refill halfway, losing returns you with no penalty, and winning gives a SkrapBook trophy and the title "Boss Rush Champion".
- **Playroom Woods map (settled 2026-11-23):**
  - Each area is its **own map**. Walking off the edge fades into the next one (Woods → Road Carpet → Block Town), like most JRPGs.
  - A **new map**, 40 × 30 tiles (about 2 × 3 screens). The user's hand-painted village stays as it is.
  - **Look:** a Ninja Adventure forest with the dark green grass, with toys mixed in from `toyset_32.png` (Lego bricks as rocks, alphabet blocks by the path, a teddy bear under a tree, playing cards on the ground).
  - **Route, bottom to top:** Demari wakes up at the bottom and finds the notebook → the tutorial clearing (Casimir vs. the Clay Sludge) → a shrine right after it → bush patches → the exit to Road Carpet at the top.
  - **The village** becomes a side area. Its path opens on the **left side after the tutorial clearing**, once Casimir has joined. New games still start in the woods.
  - **Iron Jaws' pond** is on the right, through a hidden gap in the bushes. It's a normal pond, set up like a legendary-monster encounter: **rocks in the water that you hop across** one by one to reach Iron Jaws, waiting on the far side, with the sign *"Something is ticking under the water..."* at the shore. **Hopping is automatic:** walking toward the next rock makes Demari hop onto it (a small jump and a splash sound).
  - **The tutorial comes first:** from the wake-up spot the only way out is the path to the tutorial clearing (trees block the rest). Walking into the clearing starts the tutorial. After it, the woods open up (bushes, pond, village path, exit).
- **Road Carpet map (settled 2026-11-25):**
  - A **new map**, 40 × 30 tiles like the woods. Walking up off the woods' top exit fades into its bottom; its top exit leads to Block Town (a "still being built" sign stands there until Block Town exists).
  - **Look:** a giant **patchwork rug** winding across the dark-grass forest floor, sewn from the stitched felt squares in `toyset_32.png` (red, blue, green, yellow), so it reads as "made of scrap". Props along the edges follow a **craft table / board game** theme, all from `toyset_32.png`: giant game pawns, dice, crayons and pencils lying like fallen logs, paper and cardboard scraps. None of the woods' toys (Lego, alphabet blocks, teddy bear, cards) are reused here.
  - **Royal Toy Battalion post** near the top exit: two toy-soldier guards (Ninja Adventure CamouflageGreen placeholder) salute Casimir. One grumbles: *"Another shift swap at the castle? Third one this week..."* This quietly sets up the thief's shift swap (paid off by clue 1, the torn guard's uniform).
  - **Bushes** with Pipe Spider, Paper-Dactyl and Magma Sludge (1–3 at a time, refill after 60 s), rough level 2–4.
  - **Kilnoxx's scorched clearing:** behind an **easy-to-miss gap** in the trees, charred ground (a burnt recolor of the dark grass, like the pond) with a few melted crayons around the edge and Kilnoxx waiting in the middle and the sign *"Turn back. The kiln is lit."* It replaces his temporary field spot.
  - Music: `area_road_carpet.ogg`.
- **Asmara in the party (settled 2026-11-26, for the demo):** Asmara joins the battle party at the same moment as Casimir, right after the tutorial Clay Sludge fight (she finds Casimir in the woods). She fights for the rest of Level 1 with Royal Mend, Spark Wand and Crown Light. The Ch2 castle scene must be adjusted, since she is already traveling with the party.
- **Building interiors (settled 2026-11-25):** only two, each its own small map entered through a door: the **castle throne room** (Ch2: Asmara talk, guard interruption, quest; Ch4: knighting) and the **tavern** (Ch4: thief and Zephyrion boss). The shop, train station and market stay outdoors (counter NPC, bench, wall). The flow is linear: Woods → Road Carpet → Block Town → castle → clues → A-B-C-D puzzle → clue 3 → tavern boss, with enemy levels rising per area.
- **New art packs (settled 2026-11-25):**
  - **Super Retro World Character Pack** (`Documents/Skraptopia Sprites Sheet/SuperRetroWorld_CharacterPack_Full/`): 32 small walking characters (16×20). The user chose to use it even though its license says *"You can NOT use the assets for a NFT/metaverse/IA project"* (IA = AI; our bosses and songs are AI-made). Credit required: Gif (@gif_not_jif), Noiracide (@Noiracide), Romi (@DessRomaric). Commercial use is allowed. **Use:** Block Town townsfolk (market, tavern, train station). The guards stay Ninja Adventure CamouflageGreen toy soldiers.
  - **Star Strike Free** (Arcade UI Forge): only the bullets, explosions and hit sparks, for Captain CrackJack's arm cannon and hit effects. Credit optional.
- **Animal Crossing–style voices (settled 2026-11-25):** while a dialogue line types, each letter plays a short Animalese babble (`assets/audio/game/sfx/voices/`), pitched per speaker. Deep: Casimir, guards, Zephyrion, Clay Sludge. Light: Demari, Asmara, the merchant. The Animalese license must be checked on its itch.io page before release.
- **Save points are small shrines.** Walk up and press confirm; there's no saving from the menu. Saving refills HP and MP. Locations: after the tutorial, near the Block Town shop, and outside the tavern.

### Battle

- **Side view:** Demari and Casimir on the left, the clay enemy on the right, and a backdrop made from our own map art. Party sprites are scaled 3× and step forward to act. Enemies play `idle` / `cast` / `damage`.
- **Battle layout (settled 2026-11-22; replaces the side view for clay monsters):**
  - **Clay monster fights use a front view**, as the team's photos intended: the monsters face the camera in the middle of the screen, smaller and further back. Each has its name and a small red HP bar above it, and the target arrow points at the chosen one.
  - **The party stays on screen, seen from behind:** Demari at the bottom left and Casimir at the bottom right, using the back-view frames of their sheets. The one acting steps forward.
  - **The 3 bonus bosses (Iron Jaws, Kilnoxx, Captain CrackJack) keep the side view:** the boss on the right facing left, the party on the left. **Zephyrion uses the front view** like the clay monsters (his art is a clay photo facing the camera), shown bigger in the middle (changed 2026-11-22 at the user's request).
  - **Slim HUD in every battle:** one thin message strip at the top, and one gold bar at the bottom (about 20% of the screen) with each member's portrait, Retro Inventory heart HP/MP bars, the 5 commands as Kyrise icon slots (sword Attack, book Skills, potion Items, shield Defend, boot Run) with the selected name underneath, and button hints. Mockup: `../skraptopia_dev_tools/screenshots/mockup_front_view_hud_v3.png` (script `battle_hud_mockup.py`).
- **Enemy groups:** a bush fight has 1–3 enemies picked at random from that area's list, so different types can mix. The tutorial fight and the Zephyrion boss stay one-on-one. Each enemy takes its own turn. The party gets the EXP and Buttons of every enemy in the group.
- **Targeting:** after picking Attack or a damage skill, the player moves an arrow onto the enemy they want to hit. Eraser Blast hits **all** enemies.
- **Party:** Demari and Casimir both fight and share EXP. Level cap 10.
- Both have Attack, Defend and Item. Demari can also Run. Level-ups raise HP, MP, Attack, Defense and Speed.

| Level | Demari | Casimir |
|---|---|---|
| 1 | Scribble Strike: strong hit (3 MP) | Tin Shield: takes the next hit meant for Demari (3 MP) |
| 3 | Patch Up: heals one ally (4 MP) | March Order: party Attack up for 3 turns (4 MP) |
| 5 | Eraser Blast: big damage (6 MP) | Wind-Up Charge: winds up for a turn, then deals huge damage (5 MP) |

- **More skills (settled 2026-11-25):** 6 per hero. New skills are learned on level-up (shown on the "Level up!" screen), never found in chests.

| Level | Demari | Casimir |
|---|---|---|
| 2 | Ink Splash: poisons one enemy for 3 turns | Dent Strike: a hit that lowers the enemy's Defense for 3 turns |
| 7 | Lullaby Doodle: puts one enemy to sleep for up to 2 turns (bosses can't sleep) | Cannon Volley: hits all enemies |
| 9 | Group Patch: heals the whole party | Royal Salute: party Defense up for 3 turns |

- **Doodle Casting (chosen 2026-11-25; details still being settled):** skills are cast by **drawing** them. A notebook page slides up in battle and the player traces the skill's shape with the mouse or stick; a cleaner, faster drawing makes it stronger, a sloppy one still works but weaker. Borrowed from Okami's celestial brush and Paper Mario / Sea of Stars timed hits. Awe moment: in the Zephyrion fight the SkrapBook wakes up and drawings leave a golden ink trail. **Only Demari's 6 skills are drawn** (Scribble Strike zigzag, Ink Splash circle, Patch Up plus sign, Eraser Blast scrub, Lullaby Doodle spiral, Group Patch heart); Casimir's skills and both heroes' normal attacks stay menu picks. Uses the Paper UI pack; about 3 new sounds (pencil scratch, page flip, "perfect!" chime).
  - **Settled 2026-11-25 (free draw + chains):** choosing Skills for Demari picks a target first (when there are 2+ enemies), then the notebook page opens. Small guides of every unlocked shape sit at the page edge; the player draws any of them and the game works out which one (no menu pick). The match is direction-free but **not** rotation-free (a V is not a ^). Strokes drawn less than 0.4 s apart join into one drawing, so the plus sign can be two lines in any order.
  - **Quality:** a 70–100% match gives 0.8×–1.2× power, drawing in under 1.2 s adds +10%; below 70% it fizzles (no MP spent). Status skills (Ink Splash, Lullaby Doodle) ignore power.
  - **Chains:** the page has a 5-second ink timer; draw up to 3 skills back to back, each paying its own MP. Link 2 gets +15% power, link 3 gets +30%. A fizzle or too little MP ends the chain. Cancel before the first drawing goes back to the menu.
  - **Named combos:** Ink Splash → Scribble Strike = **Ink Storm** (the hit also lowers a poisoned enemy's Defense); Scribble Strike → Eraser Blast = **Clean Slate** (already hits all, so it gets +25% instead); Lullaby Doodle → Eraser Blast = **Rude Awakening** (double damage on a sleeping enemy, which wakes); Patch Up → Group Patch = **Bandage Party** (the heal also clears poison from the party, once party poison exists; until then +25% heal).
- **Status icons** float above whoever has the effect, from Ninja Adventure `Skill Icon/`: poison `Spell/OrbPlant`, sleep `Meteo/Moon`, Defense down `Spell/Downgrade`, Defense up `Spell/DefenseUpgrade`, Attack up `Spell/AttackUpgrade`. Sounds from the user's `RPG_Essentials_Free.zip` (Poison, Sleep, Debuff, Def buff, Heal).

- **Money is Buttons.** Enemies drop them, and Asmara gives some at the start of the quest.
- **Shop (Block Town):** Glue Stick (30 HP, 15 Buttons), Juice Box (15 MP, 20), Bandage Tape (full heal, one ally, can revive, 60). The village merchant sells the same three for now.
- **Leveling (built 2026-11-25):** Demari and Casimir share one level. EXP to reach each level: 20, 50, 100, 170, 260, 380, 530, 720, 950 (level 10). Each level: Demari HP+8 MP+3 ATK+3 DEF+2 SPD+1; Casimir HP+10 MP+2 ATK+3 DEF+2 SPD+1. Poison does 10% of max HP per turn; Defense down = +30% damage taken; Defense up = -30%.

| Move | Effect |
|---|---|
| Attack | Ninja Adventure Cut |
| Scribble Strike | Ninja Adventure CutX |
| Patch Up | Super Pixel Magic Burst (green) |
| Eraser Blast | Super Pixel Explosion |
| Tin Shield / March Order | Super Pixel Symbols |
| Wind-Up Charge | Ninja Adventure Thunder, then Super Pixel Impact |
| Enemy hits | Ninja Adventure Claw |
| Zephyrion | Ninja Adventure Rock / RockSpike |

- **Credits** must include "Super Pixel Effects by Will Tice / unTied Games", "Icons by Kyrise" (CC BY 4.0) and "Retro Inventory by ElvGames", plus the Pocket Inventory, Paper UI and 500 Bullets packs once their license PDFs are checked.
- **Music and sound:** Ninja Adventure audio, plus the user's own Suno boss songs.
- **Captain CrackJack's shots** use the 500 Bullets 24×24 pack.

### Menus and controls (settled 2026-11-22)

- **Look:** the Pocket Inventory (Pixel Map) pack for the pause and settings menus. The Paper UI pack is saved for the SkrapBook (Phase 5), and Retro Inventory for the item screens (Phase 3).
- **Pause menu:** Status, Quests, Settings, Restart, Resume, and Boss Rush once it's unlocked.
  - **Settings:** boss music (Instrumental, the default, or Lyrics), music volume and sound volume. Choices are remembered between sessions.
  - **Restart:** goes back to the last shrine save after an *"Are you sure?"* Yes/No. Until shrines exist, it restarts the game from the beginning.
- **Button hints** switch automatically: controller icons after a controller press, keyboard icons after a key press (Ninja Adventure input icons).
- **Controls page** (Phase 6): rebind every action for keyboard and controller. Picking a key that's already used swaps the two actions. There's a Reset to default, and the choices are saved.

### Art

- **Demari:** the real sheet (`Documents/Skraptopia Sprites Sheet/demari.png`, 4×4 of 32×48).
- **Placeholders until the real art arrives:**
  - ~~Asmara: Ninja Adventure `Princess`.~~ **Replaced 2026-11-26** by the team's real sheet (`Princess Asmara.png`, 4×4 of 32×48, same layout as Demari's), used in battle and for her throne-room NPC.
  - Casimir: Ninja Adventure `Knight`.
  - Guards (the Royal Toy Battalion): Ninja Adventure `CamouflageGreen`.

### Team workflow

- `jj921` re-downloads a fresh copy once. After that, `main` gets cleaned.
- Teammates send art to Mario. Claude brings it into the project.
- Work happens on branches, and only playable builds get merged into `main`.

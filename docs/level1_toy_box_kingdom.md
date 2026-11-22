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
  | Rage line | *"Its spring winds tighter!"* (red eye flashes) | *"Its feathers ignite!"* (turns white-gold, palette shader) | *"He blasts off into the air!"* (hovers; takes 30% less damage while raging) |
  | Special | **Clockwork Frenzy:** bites one target twice | **Inferno Wings:** hits both party members | **Liberty Dash:** hits both party members |
  | Drop | **Steel Fang:** the party deals +15% damage | **Phoenix Feather:** once per battle, revives the first knocked-out ally at half HP (*"The Phoenix Feather glows!"*) | **Star Medal:** the party takes 15% less damage |
  | Icon | Kyrise `necklace_03e` | Ninja Adventure `Resource/feather.png` | Kyrise `necklace_02d` |

  - **Boss music:** each bonus boss has the user's own Suno song in two versions. The **instrumental** plays by default; Settings can switch boss fights to the **lyrics** versions. Zephyrion keeps "Clay Doesn't Pay" (one version only).
  - **Boss Rush** (Phase 6): unlocks after beating all 4 bosses (Zephyrion, Iron Jaws, Kilnoxx, Captain CrackJack). A Boss Rush option appears in the pause menu: all 4 back to back, HP and MP refill halfway, losing returns you with no penalty, and winning gives a SkrapBook trophy and the title "Boss Rush Champion".
- **Save points are small shrines.** Walk up and press confirm; there's no saving from the menu. Saving refills HP and MP. Locations: after the tutorial, near the Block Town shop, and outside the tavern.

### Battle

- **Side view:** Demari and Casimir on the left, the clay enemy on the right, and a backdrop made from our own map art. Party sprites are scaled 3× and step forward to act. Enemies play `idle` / `cast` / `damage`.
- **Battle layout (settled 2026-11-22; replaces the side view for clay monsters):**
  - **Clay monster fights use a front view**, as the team's photos intended: the monsters face the camera in the middle of the screen, smaller and further back. Each has its name and a small red HP bar above it, and the target arrow points at the chosen one.
  - **The party stays on screen, seen from behind:** Demari at the bottom left and Casimir at the bottom right, using the back-view frames of their sheets. The one acting steps forward.
  - **Boss fights (Iron Jaws, Kilnoxx, Captain CrackJack, Zephyrion) keep the side view:** the boss on the right facing left, the party on the left.
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

- **Money is Buttons.** Enemies drop them, and Asmara gives some at the start of the quest.
- **Shop (Block Town):** Glue Stick (30 HP), Juice Box (15 MP), Bandage Tape (full heal, one ally, expensive).

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
  - Asmara: Ninja Adventure `Princess`. The team's princess file was a duplicate of Demari's, so we're waiting on the real one.
  - Casimir: Ninja Adventure `Knight`.
  - Guards (the Royal Toy Battalion): Ninja Adventure `CamouflageGreen`.

### Team workflow

- `jj921` re-downloads a fresh copy once. After that, `main` gets cleaned.
- Teammates send art to Mario. Claude brings it into the project.
- Work happens on branches, and only playable builds get merged into `main`.

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

## Open questions (team must settle these)

The group docs disagree with each other here. Until each one is answered, the game shouldn't commit to either side.

- [ ] The witch's name: **Yasireth** (narrative doc), **Yalboa** (design doc), or just "the Arts n' Krafts Witch"? Pronouns: "his" or "them"?
- [ ] Is Zephyrion a "dirt clay dragon" or a "terracotta dragon"? The clay model looks like a one-eyed humanoid, not a dragon.
- [ ] Is Casimir a tin soldier, or something with a fin ("My arm! I mean, fin!")?
- [ ] Is the tutorial enemy a slime or the Clay Sludge?
- [ ] Is the Clay Sludge "Person B" from the theft plan?
- [ ] Who is Person A (the thief)? Do they ever get caught?
- [ ] Bosses: the walkthrough lists the Witch as a Level 1 boss, but the design doc says the witch doesn't appear. Assumed: the witch doesn't appear.
- [ ] Is Mecha Orc one enemy or two (knight and lancer)? Do Amfurrbians and Nappin Susa appear in Level 1?
- [ ] Does Zephyrion die or flee? ("dies as he was")
- [ ] Do Block Town, Playroom Woods and Witch's Workshop all belong in Level 1?

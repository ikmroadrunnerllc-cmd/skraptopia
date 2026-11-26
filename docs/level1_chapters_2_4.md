# Level 1: Chapters 2–4 (finishing the level)

Written 2026-11-26. The story comes from `level1_toy_box_kingdom.md` and the Level 1 dramatic design doc; this file only says how it gets built.
Each chapter gets its own branch, a gate, and one test by the user. Battle phase B3 (jobs + passives) waits until after Chapter 4.

## Changes because Asmara is in the party (demo decision, 2026-11-26)

- **Ch2:** Asmara walks back to her castle with Demari and Casimir. In the throne room she sits on her throne, hears Demari's story, then the guard bursts in. The beats are the same; she just arrives with you.
- **Ch3:** Asmara stays in the party for the investigation ("It's my book. I'm coming.").
- **Ch4:** after the knighting, Asmara stays at the castle. Demari leaves the kingdom with Casimir, as the design doc says.

## Chapter 2: The castle  (target: Nov 28)  status: building
Goal: walk from Road Carpet into Block Town, enter the castle, and get the quest.
Builds:
- **Block Town** map (builder script, Ninja Adventure tiles, the layout already agreed): castle at the top middle, shop and shrine spot at the entrance, market on the left, toy train station on the right, tavern at the top left, and bushes on the edges with the outskirts enemies (Paper-Dactyl, Mecha Orcs, Frost Spider, Ink-Dactyl, rare Gold Orc Knight).
- The Road Carpet top exit leads to Block Town.
- **Castle throne room** (a small interior map; the door in Block Town leads in).
- **Story scene:** Asmara takes her throne. Demari explains, and Asmara tells them about Yalboa, the witch's castle in the far south, and the kingdoms in between. The guard rushes in: "The SkrapBook has been stolen!" Asmara's deal: bring it back for passage and resources. She gives the starting Buttons. Flags `quest_skrapbook`.
- A few townsfolk lines that keep the witch's influence felt (Ninja Adventure placeholders, Royal Toy Battalion guards).
Gate C2:
- [ ] C2.1 No errors on import or a game run
- [ ] C2.2 Playtest: Road Carpet → Block Town → castle; the scene plays once and sets the quest flag and Buttons; you can't walk through buildings; old checks pass
- [ ] C2.3 Screenshots: Block Town and the throne room scene
- [ ] C2.4 The user walked in, got the quest and said OK

## Chapter 3: Investigation  (target: Dec 1)  status: todo
Goal: find the thief's messages and work out where the meeting is.
Builds:
- **Clue 1** (train station bench, a torn guard's uniform) and **clue 2** (market wall note, "Sludge kept the tin soldier busy... easy as A, B, C"), in any order.
- **A-B-C-D block puzzle** blocking the back alley: push blocks one tile at a time, the right order opens the alley, and a reset spot puts them back.
- **Clue 3** (barrel behind the tavern): "Meet at the tavern when the bells ring. Bring the book." It unlocks the tavern door.
- **Shrines:** walk up and confirm to save and refill HP/MP. "Continue" on the title screen loads the save (level, items, Buttons, flags, notebook).
Gate C3:
- [ ] C3.1 No errors on import or a game run
- [ ] C3.2 Playtest: clues in either order, clue 3 only after both, the puzzle (right order opens it, wrong order doesn't, reset works), and save/load restores everything
- [ ] C3.3 Screenshots: each clue, the puzzle, a shrine
- [ ] C3.4 The user solved it and said OK

## Chapter 4: Climax  (target: Dec 3)  status: todo
Goal: catch the thief, beat Zephyrion, become a knight, and leave the kingdom.
Builds:
- **Tavern interior:** the thief hands the SkrapBook to Zephyrion, Zephyrion causes a scene, and the thief escapes and drops the Yalboa sewing-needle badge. Then the dragon joke and the **boss fight**.
- After the win: his last line, he crumbles into dirt, the notebook pages fly into the SkrapBook, and Demari can use it (the reversal).
- **Knighting** in the throne room: Asmara is surprised and makes Demari her personal knight, then grants passage.
- **Ending** text screens: Demari leaves the Toy Box Kingdom with Casimir. Then back to the title.
Gate C4:
- [ ] C4.1 No errors on import or a game run
- [ ] C4.2 Playtest: the story flags happen in order (tutorial → castle → clues → boss → knighting → ending)
- [ ] C4.3 Screenshots: tavern, boss, knighting, ending
- [ ] C4.4 The user played Level 1 start to finish and said OK

## After the story (Dec 4–6)
- **Target length: about 1 hour of play for Level 1** (user, 2026-11-26). The story chapters come first. Then add in-between content (side areas, extra fights, townsfolk errands) until a playthrough takes about an hour. Nothing extra goes in before the story is finished.
- Polish and balance, then battle phase B3 (jobs + passives) if there's time, then B4 and B5.

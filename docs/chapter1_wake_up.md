# Chapter 1: Wake-up

**Branch:** `chapter-1-wake-up` · **Target:** Nov 27, 2026 · **Status:** waiting for the user test

The first chapter of Level 1, playable from start to end: from the title screen to Casimir joining the party. The story doc (`level1_toy_box_kingdom.md`) wins if anything here disagrees.

## What the player sees

1. **Title screen:** "SkrapTopia" and **New Game**. (Continue appears in Chapter 3, once shrines can save.)
2. **Opening:** 3 text screens. Each fades in and waits for confirm:
   1. *"Demari found a strange old game at a little game shop. It was called SkrapTopia."*
   2. *"Back home, Demari pressed Start. The screen flashed... and pulled them right inside!"*
   3. *"Demari woke up in a forest made of paper and toys. A plain notebook lay in the grass nearby."*
3. **Playroom Woods:** Demari wakes up at the bottom of the woods. The **notebook** lies in the grass nearby. Walking over it picks it up (*"You found a plain notebook!"*). It becomes the SkrapBook in Chapter 4.
4. **Tutorial scene:** walking up the path into the clearing starts a short scene:
   > **Casimir:** Move, you nasty blob of sludge, I MUST get to the princess!!
   > **Clay Sludge:** Not a chance, you dweeb!
   > *The Clay Sludge attacks Casimir.*
   > **Casimir:** Oh goodness, great heavens! My arm! My freshly polished arm!
   > **Clay Sludge:** HAHAHAHA!
   > **Demari:** STOP! Stop attacking him right now!
   > **Clay Sludge:** Or what?
   > **Demari:** Or I'll fight you!
5. **Tutorial battle** against the Clay Sludge.
6. **After the battle:**
   > **Casimir:** Thank you for saving me! Are you traveling by yourself?
   > **Demari:** Not exactly... I need help. I don't know where I am. And this place is strange.
   > **Casimir:** Come with me and I'll take you to Princess Asmara. She'll be able to help you.
   > **Demari:** Oh, thank you!
   > **Casimir:** It's the least I can do for you saving me.
7. **Casimir joins** and **follows Demari** around the woods, Road Carpet and the village.

Every line uses the Animal Crossing–style babble voices (deep for Casimir and the Clay Sludge, light for Demari).

## Art

- Casimir: the Ninja Adventure `Knight` placeholder (until the team's tin soldier art arrives).
- Demari fights the tutorial battle alone (Casimir is hurt); he joins right after.
- Clay Sludge: the team's clay photo, as in the woods now.
- Notebook: a paper sheet from `toyset_32.png`.

## Gate (checks before Chapter 1 is done)

- [x] C1.1 Headless import and run: 0 errors.
- [x] C1.2 Playtest: the game starts on the title screen; New Game shows the 3 opening screens in order, then the woods.
- [x] C1.3 Playtest: walking over the notebook picks it up once (it stays gone after leaving and coming back).
- [x] C1.4 Playtest: entering the clearing plays the tutorial scene, then the battle; winning plays the thank-you scene, and Casimir follows Demari, also after changing maps.
- [x] C1.5 All old playtest checks still pass (266/266 PASS).
- [x] C1.6 Screenshots: title, an opening screen, the tutorial scene, Casimir following.
- [ ] C1.7 The user played from New Game to Casimir joining and said OK.

## Not in this chapter

Block Town, Princess Asmara, the quest and saving all come in Chapters 2 and 3.

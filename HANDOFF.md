# Handoff: where we left off (2026-10-18)

## Done so far
- Sliced the AI toy sheet into `toyset_32.png` (128 transparent 32px toys).
- Replaced the platformer player script with top-down 4-way movement.
- Built a test bedroom in `game.tscn`: Mana Seed floor/walls, toys with collision, Y-sort, a camera that follows the player.
- Chose **Ninja Adventure** as the main art pack and built `tilesets/ninja_adventure.tres`: all 23 sheets, 12 paintable terrains, nature objects as whole stamps with collision.
- Made `path_example.tscn` to show how terrain painting works.
- Added the Godot MCP server (restart Claude Code if its tools are missing).

## The game plan (Level 1: Toy Box Kingdom)
Story: Demari loads the cursed game "SkrapTopia", is pulled inside, saves Casimir (a tin soldier) from a clay sludge, meets Princess Asmara (a doll), and must recover her stolen Skrapbook. Clues lead to a tavern, ending in a boss fight with Zephyrion the clay dragon (who only took the job for money). Asmara then knights Demari.

Level 1 is **3 scenes**:
- `overworld`: **Playroom Woods** (starting area) + **Block Town** in one map
- `throne_room` (Asmara)
- `tavern` (thief + Zephyrion boss)

Build order: doors between maps → NPC dialogue → one simple turn-based battle → finish one full section → copy for the rest → title/ending/credits.

Scope cuts (don't build these): open world, inventory, leveling, party, save system, branching dialogue.

## Next up: the starting area (Playroom Woods)
Use the **Grass & Dirt** terrain (set 2), not desert. Planned layout, about 30x20 tiles:
- An open clearing at the bottom where Demari **drops from the sky**. Mark it with a `Marker2D` named `DropSpot`.
- A dirt path winding north with one bend.
- The Casimir vs clay sludge fight halfway along. Mark it with a `Marker2D` named `BattleSpot`.
- The kingdom gate at the top (exit to Block Town).
- A thick ring of trees (Nature source 6) as the walls.

Layers: `Ground` (terrain) / `Decor` (flowers, pebbles) / `Objects` (Y Sort: trees, toys, player, NPCs).

The user offered to block out this map: ground + path + tree border + markers, then decorate it themselves to learn.

## Still to do / open items
- Switch `game.tscn`'s `Ground` from Mana Seed to `ninja_adventure.tres`, and remove the Mana Seed folder (license conflict with AI).
- Swap the knight player for a Ninja Adventure character (`Boy` or `Child`) with 4-direction walk animations.
- Make Casimir: recolor Ninja Adventure `Knight` silver/red. Thief = `NinjaDark`. Clay sludge = recolor `Slime` brown. Zephyrion = recolor `DragonGreen` boss terracotta.
- Add collision to houses/water if needed (only nature objects and the 10 placed toys have it now).
- The "falling from the sky" intro: player starts above `DropSpot`, drops down, smoke puff (Ninja Adventure FX).
- Story naming to settle: terracotta vs clay vs dirt-clay dragon; Skrapbook vs sketchbook; is Yasireth the Arts n' Crafts Witch?; slime vs clay sludge.
- Credits screen: Will Tice / unTied Games (effects), Brackeys (CC0), Pixel-boy / Ninja Adventure (CC0, credit optional), AI-generated toy art. Check the class's rules on disclosing AI use.

## Notes
- Helper scripts (slicing, terrain and nature builders) lived in a temp scratchpad and may be gone. They're easy to regenerate. See "Tools" in `CLAUDE.md`.
- Backups of earlier `game.tscn` versions were in the same temp folder.

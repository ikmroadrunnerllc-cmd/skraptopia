# SkrapTopia

A small toy-themed top-down JRPG made in **Godot 4.7.2** for a **school project** (not being released). The user is a beginner on a time crunch: explain things simply, step by step, and keep the scope small.

## Working with the user
- Explain in plain language and teach as you go. The user wants to learn, not just get results.
- The user prefers **scene/node and TileSet changes over new game code**. Ask before adding scripts.
- The Godot editor is usually open. After editing `.tscn`/`.tres` files, tell the user to click **Reload** (not Save) when Godot asks.
- Back up a scene before rewriting it.

## Tools
- Godot executable: `C:/Users/lolst/Downloads/New folder/Godot_v4.7.2-stable_win64_console.exe`
- A Godot MCP server (`godot`, `@coding-solo/godot-mcp`) is configured for this project and can run the game and read its errors.
- Useful pattern: write a throwaway `extends SceneTree` script in the scratchpad and run it with `--headless --path . --script <file>` to build or inspect resources with Godot's own API, so the file format is always right.
- **Screenshots need a window.** Run *without* `--headless`, wait ~10 `process_frame`s, then call `root.get_texture().get_image().save_png()`. With `--headless` the screenshot call hangs.
- A safety hook (GateGuard) blocks the first Bash/Write of a session until you state the request and what the command does. State those facts, then retry.

## Art and assets
| Asset | Use | License |
|---|---|---|
| **Ninja Adventure** (`Ninja Adventure - Asset Pack/`) | **Main pack.** 16px tiles, characters with 4-direction walks, monsters, UI, music, sound effects | CC0, no restrictions |
| **AI toy sheet** `Assets/AI_Created_Assets/toyset_32.png` | Big toy props/NPCs: 16x8 grid of **32px** tiles, transparent background (sliced from the original AI sheet) | AI-generated |
| **Super Pixel Effects** | Battle/spell effects | Credit "Will Tice / unTied Games" |
| **Brackeys assets** | Sounds, music, font, the current knight player sprite | CC0 |
| **Mana Seed** | Currently only the bedroom walls/floor in `game.tscn` | **Its license forbids use with any AI (art or code).** The user knows and chose to use it anyway. The plan was to replace it with Ninja Adventure. |

Rules: world tiles are **16px**; toys are 32px props on top. The project's default texture filter is Nearest (crisp pixels).

## Key files
- `game.tscn` (main scene): `Ground` (TileMapLayer, Mana Seed interior) → `Objects` (Node2D, **Y Sort on**) holding `Toys` (TileMapLayer, toy sheet, Y Sort on) and `Player` (with `Camera2D` child, zoom 4, limits 320x224) → `RoomBounds` (3 invisible walls). Painting outside the room requires raising the camera limits and moving/removing `RoomBounds`.
- `player.gd`: top-down 4-way movement, `SPEED = 80`, using ui_* actions. `player.tscn`: Brackeys knight sprite, feet-origin collision circle.
- `tilesets/ninja_adventure.tres`: **one TileSet with every Ninja Adventure sheet.** Physics layer 0 is used for collision.
  - Source ids: 0 Floor, 1 Water, 2 InteriorFloor, 3 FloorB, 4 FloorDetail, 5 Field, **6 Nature**, 7 House, 8 Desert, 9 Towers, 10 VillageAbandoned, 11 Relief (cliffs), 12 ReliefDetail, 13 Hole, 14 Dungeon, 15 Element, 16 Logic, 17 Pipes, 18 bed, 19 camp, 20 Interior, 21 WallSimple, 22 Interior Elements, 23 PondDarkGrass (`tilesets/pond_dark_grass.png`, the grass pond recolored to Dark Grass).
  - **13 corner terrains** (Match Corners; terrain 0 = Ground, 1 = path/water/floor): 0 Sand, 1 Pink Sand, 2 Grass & Dirt, 3 Dark Grass & Dirt, 4 Snow, 5 Dark Dirt, 6 Pond (sand), 7 Ice Pond (snow), 8 Pond (grass), 9 Poison Pond (dirt), 10 Tan Tile Floor, 11 Green Tile Floor, 12 Pond (dark grass).
  - Not terrains (place by hand): ice/lava pools, the brick/cobble interior floors, cliffs.
  - **Source 6 (Nature):** 133 objects, each one multi-cell tile (whole tree/rock per click), trunk/base collision on big ones, Y-sort origin at the bottom.
- `path_example.tscn`: a T-shaped sand path painted with the terrain brush, a teaching example.
- `Assets/AI_Created_Assets/AI_ToySetTitle (1).png`: the original 2752x1536 AI sheet (kept).

## Gotchas
- Terrain painting fails if a path reaches the outermost row of the painted ground. Paint ground at least one row past where paths end.
- Two different terrain sets can't blend on one layer (holes appear). Ponds go on their own `Water` layer: paint the pond set's Ground a few cells wider first, then the water inside.
- Ninja Adventure floor-sheet layout per block: 3x3 nine-slice at block offset (0..2, 0..2), 1-wide strips at col 3 / row 3, inside corners at (5..6, 1..2), ground fill at (0,5), tuft variants at (1..4,5).

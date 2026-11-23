# Skraptopia

A fresh start for a top-down 2D JRPG in Godot 4.7.2.
Learn by building small playable steps with placeholder art.

## How to play

1. Open `project.godot` in Godot 4.7.2 and let the imports finish.
2. Press **F5** (Run Project). You start in the village.
3. Move with **WASD**, the arrow keys or a controller. Talk/confirm with
   **E**, Space or Enter (A on a controller). Open the menu with **Esc** or Tab.

## How to get into the boss fights

Run the game from Godot with **F5**, walk around the village or the field,
then press one of these keys:

| Key | Fight |
|---|---|
| F1 | Iron Jaws (bonus boss) |
| F2 | Kilnoxx, the Kiln Phoenix (bonus boss) |
| F3 | Captain CrackJack (bonus boss) |
| F4 | Zephyrion, the Dirt Clay Dragon (story boss) |
| F6 | A random group of 1-3 clay monsters |
| F7 | Mecha Orc Knight |

- The keys only work when you run the game from Godot (debug runs), not in an exported build.
- Each key refills the party's HP and MP first.
- **F1-F4 make the party strong enough** (about level 8) to get each boss
  to half HP, so you can see its **rage form**: the rage line, the screen shake
  and its special move. F6 and F7 put the party back to normal.
- In battle, pick **Attack** with E / Enter. When a boss is below half HP it rages.
- To hear the boss songs with lyrics, open the menu (Esc) and switch
  **Boss music** to Lyrics.

## Preserved files

- `assets/packs/`: downloaded art, audio, effects, and their licenses.
- `assets/art/`: toy art and the custom pond image.
- `assets/branding/`: the project icon.
- `resources/tilesets/ninja_adventure.tres`: the configured main TileSet.
- `resources/tilesets/bedroom_interior.tres`: saved from the old map.
- `resources/tilesets/toy_props.tres`: saved toy tiles and collision.
- `addons/`: existing Godot plugins.

The main TileSet contains 24 atlas sources and 13 terrain sets.
World tiles are 16 pixels. Existing toy props use 32-pixel tiles.
Downloaded asset folders retain their original licenses and documentation.

## First learning goal

Build one small overworld: a tile map you can walk around in.
Start with a clearing and path, then add a placeholder player,
obstacles, and a following camera. Discuss each step before adding it.
After that, work toward one enemy and a simple JRPG battle.

# Skraptopia

A fresh start for a top-down 2D JRPG in Godot 4.7.2.
Learn by building small playable steps with placeholder art.

## Current state

The previous maps, player, scripts, and plans are archived outside the
project under `../skraptopia_backups/`. They can be restored later.
There is no gameplay scene or startup scene yet.

Open `project.godot` in Godot and let asset imports finish.
Reopen the editor after the reset. If asked about external changes,
choose Reload instead of saving an old scene back into the project.
F5 will ask for a main scene until we create one together.

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

## Useful custom skills to discuss

- Learning coach: teach one small Godot task and check understanding.
- Terrain helper: paint paths, water, collision, and sorted scenery.
- Battle helper: build and explain one small turn-based encounter.
- Project checker: check resource links, scene loading, and runtime errors.

These are proposed skills; they have not been installed yet.
Project-specific facts belong in `AGENTS.md`; skills should provide
reusable workflows rather than duplicate the project notes.

## Godot tools

The current chat can read project files and run the local Godot executable.
A Godot MCP connection is optional and must be exposed to the current
assistant before it can be used. A Claude-only connection is separate.

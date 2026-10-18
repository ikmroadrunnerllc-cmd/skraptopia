---
name: skraptopia-safe-changes
description: "Use when about to edit, create, delete, or regenerate any file in SkrapTopia (.tscn, .tres, .gd, .png, project.godot, CLAUDE.md), including through Godot headless scripts. Save-first, memory note, backup, minimal change, commit to a branch."
---

# SkrapTopia: Safe Changes

The user is a beginner with the Godot editor usually open. Every change follows these steps, in order.

## 1. Ask the user to save first
Before touching any file Godot has open (scenes, TileSets), ask the user to press **Ctrl+S** in Godot and **wait for them to confirm**.
Why: when they click Reload after the edit, Godot throws away anything unsaved. Painted work was lost this way once.

## 2. Write a memory note
Before the change, add a short note to the project memory: what will change, which files, and why. Keep one running memory file of recent changes rather than one file per change.

## 3. Back up
Commit the files about to be changed to the work branch *before* editing them (see step 5). That commit is the backup.
For a file not tracked by git, also copy it to `backups/<file>_<YYYY-MM-DD_HHMM>` in the project.
Do not rely on the session scratchpad for backups. It gets deleted.

## 4. Change only what was asked
- Don't change the scene layout (nodes, positions, painted tiles, camera, collision) or code unless it is needed for the request or is part of the agreed plan in `HANDOFF.md`.
- Don't "tidy up" nearby things. Mention them instead.
- Ask before adding new scripts (from `CLAUDE.md`).
- After a Godot headless save, diff against the backup. Godot's saver strips `uid="..."` tags and adds overrides. Restore anything that wasn't part of the change.

## 5. Commit to a branch
- Never commit to `main`. Work on a branch (`git switch -c <short-topic>`, or reuse the current work branch).
- Commit only the files you changed. Don't `git add -A`: big asset packs are untracked on purpose.
- Use a plain-language commit message saying what changed and why.

## 6. Tell the user
List what changed, where the backup is, and the branch name. Remind them to click **Reload** (not Save) in Godot.

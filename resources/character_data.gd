class_name CharacterData
extends Resource
## Immutable template for a playable character. Runtime values (current HP, EXP) live in GameState.

@export var id: StringName = &"hero"
@export var display_name: String = "Hero"
@export var level: int = 1
@export var max_hp: int = 40
@export var max_mp: int = 10
@export var attack: int = 8
@export var defense: int = 3
@export var speed: int = 6

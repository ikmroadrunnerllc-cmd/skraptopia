class_name EnemyData
extends Resource
## Immutable enemy template. Battle HP is copied into runtime state, never written back here.

@export var id: StringName = &"slime"
@export var display_name: String = "Slime"
@export var sprite_sheet: Texture2D                ## Optional; a placeholder is drawn when missing.
@export var hframes: int = 4
@export var vframes: int = 4
@export var portrait: Texture2D                     ## Optional battle portrait.
@export var max_hp: int = 30
@export var attack: int = 5
@export var defense: int = 2
@export var speed: int = 4
@export var exp_reward: int = 10
@export var ai: StringName = &"basic_attack"       ## Behaviour id used by the battle scene.

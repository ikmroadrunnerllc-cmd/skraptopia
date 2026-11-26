class_name SkillData
extends Resource

@export var id: StringName = &""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var user: StringName = &"demari"
@export var unlock_level: int = 1
@export var mp_cost: int = 0
@export_enum("damage", "heal", "shield", "buff", "charge", "status") var kind: String = "damage"
@export var power: float = 1.0
@export var turns: int = 0
@export var hits_all: bool = false
@export var effect: StringName = &""
@export var status: StringName = &""
@export var doodle: Array[PackedVector2Array] = []

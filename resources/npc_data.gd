class_name NPCData
extends Resource

@export var id: StringName = &""
@export var display_name: String = "Villager"
@export var sprite_sheet: Texture2D
@export_range(0, 3) var facing: int = 0
@export var row_per_direction: bool = false
@export var dialogue: DialogueData
@export var quest: QuestData
@export var sells: Array[ItemData] = []

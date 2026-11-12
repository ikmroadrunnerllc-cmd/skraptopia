class_name QuestData
extends Resource

@export var id: StringName = &""
@export var title: String = ""
@export_multiline var description: String = ""
@export var target_enemy_id: StringName = &""
@export var required_count: int = 1
@export var reward_exp: int = 0
@export var offer_dialogue: DialogueData
@export var accepted_dialogue: DialogueData
@export var declined_dialogue: DialogueData
@export var active_dialogue: DialogueData
@export var ready_dialogue: DialogueData
@export var completed_dialogue: DialogueData

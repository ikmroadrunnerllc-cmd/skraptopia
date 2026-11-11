class_name NPCData
extends Resource
## Editable NPC definition. Facing: 0 down, 1 up, 2 left, 3 right (Ninja Adventure sheet columns).

@export var id: StringName = &""
@export var display_name: String = "Villager"
@export var sprite_sheet: Texture2D                ## 4 columns (down, up, left, right) x 7 rows of 16 px.
@export_range(0, 3) var facing: int = 0
@export var dialogue: DialogueData                  ## Default conversation.
@export var quest: QuestData                        ## Optional quest this NPC gives and receives.

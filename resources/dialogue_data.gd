class_name DialogueData
extends Resource
## One conversation: lines shown in order, then optional choices on the last line.

@export var speaker: String = ""            ## Optional; overrides the NPC name when set.
@export_multiline var lines: Array[String] = []
@export var choices: Array[String] = []      ## Empty = no choice; otherwise shown after the last line.

class_name Signpost
extends StaticBody2D

@export var message: DialogueData


func _ready() -> void:
	$Prompt.hide()
	$InteractionZone.body_entered.connect(func(b: Node) -> void: if b.has_method("add_interactable"): b.add_interactable(self))
	$InteractionZone.body_exited.connect(func(b: Node) -> void: if b.has_method("remove_interactable"): b.remove_interactable(self))


func set_prompt_visible(value: bool) -> void:
	$Prompt.visible = value


func interact(_player: Node2D) -> void:
	await Dialogue.play(message, "Sign")

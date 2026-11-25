class_name Pickup
extends Area2D

@export var flag: StringName = &""
@export_multiline var message: String = ""


func _ready() -> void:
	if GameState.has_flag(flag):
		queue_free()
		return
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player") or GameState.has_flag(flag) or SceneManager.busy:
		return
	GameState.set_flag(flag)
	hide()
	var d := DialogueData.new()
	d.lines.append(message)
	await Dialogue.play(d)
	queue_free()

class_name SceneExit
extends Area2D
## Walking into this area moves the player to another scene, at the Marker2D named `target_spawn`.

@export_file("*.tscn") var target_scene: String = ""
@export var target_spawn: String = ""


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and target_scene != "" and not SceneManager.busy:
		SceneManager.change_to(target_scene, target_spawn)

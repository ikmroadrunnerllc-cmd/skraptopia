extends CanvasLayer
## Autoload "SceneManager": fades between scenes, places the player at a spawn, starts and ends battles.

const BATTLE_SCENE := "res://Scenes/battle/battle.tscn"
const VILLAGE_SCENE := "res://Scenes/main.tscn"

var busy: bool = false
var _fade: ColorRect


func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.modulate.a = 0.0
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_fade)


## Go to a scene; place the player at the Marker2D named `spawn` (group "spawn"), or at `position` if given.
func change_to(scene_path: String, spawn: String = "", position: Variant = null) -> void:
	if busy:
		return
	busy = true
	GameState.lock(&"transition")
	Dialogue.abort()
	await _fade_to(1.0)
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await get_tree().process_frame
	_place_player(spawn, position)
	await _fade_to(0.0)
	busy = false
	GameState.unlock(&"transition")


func start_battle(enemy: EnemyData, encounter_id: String) -> void:
	if busy or enemy == null:
		return
	var scene := get_tree().current_scene
	var player := get_tree().get_first_node_in_group("player") as Node2D
	GameState.pending_battle = {
		"enemy": enemy,
		"encounter_id": encounter_id,
		"return_scene": scene.scene_file_path,
		"return_position": player.global_position if player else Vector2.ZERO,
		"start_hp": GameState.hp,
	}
	change_to(BATTLE_SCENE)


func return_from_battle() -> void:
	var b := GameState.pending_battle
	change_to(b.get("return_scene", VILLAGE_SCENE), "", b.get("return_position", null))


func retry_battle() -> void:
	GameState.set_hp(GameState.pending_battle.get("start_hp", GameState.HERO.max_hp))
	change_to(BATTLE_SCENE)


func _place_player(spawn: String, position: Variant) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	if position is Vector2:
		player.global_position = position
		return
	for marker: Node in get_tree().get_nodes_in_group("spawn"):
		if marker.name == spawn and marker is Node2D:
			player.global_position = (marker as Node2D).global_position
			return


func _fade_to(alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(_fade, "modulate:a", alpha, 0.25)
	await tween.finished

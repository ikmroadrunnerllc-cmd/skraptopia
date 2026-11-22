extends CanvasLayer

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


const TEST_BOSSES := {
	KEY_F1: "iron_jaws",
	KEY_F2: "kilnoxx",
	KEY_F3: "captain_crackjack",
	KEY_F4: "zephyrion",
	KEY_F7: "mecha_orc_knight",
}
const TEST_MONSTERS: Array[String] = [
	"clay_sludge", "pipe_spider", "paper_dactyl", "mecha_orc_knight", "mecha_orc_lancer",
	"magma_sludge", "frost_spider", "ink_dactyl", "gold_orc_knight",
]


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build() or not event is InputEventKey or not event.pressed or event.echo:
		return
	if GameState.is_locked() or get_tree().get_first_node_in_group("player") == null:
		return
	var key: Key = event.keycode
	if TEST_BOSSES.has(key) or key == KEY_F6:
		GameState.restore_party()
	if TEST_BOSSES.has(key):
		start_battle(load("res://data/enemies/%s.tres" % TEST_BOSSES[key]), "test_" + TEST_BOSSES[key])
	elif key == KEY_F6:
		var group: Array = []
		for i in randi_range(1, 3):
			group.append(load("res://data/enemies/%s.tres" % TEST_MONSTERS.pick_random()))
		start_battle(group, "test_group")
	else:
		return
	get_viewport().set_input_as_handled()


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


func start_battle(enemies: Variant, encounter_id: String, backdrop: String = "woods") -> void:
	var list: Array = (enemies if enemies is Array else [enemies]).filter(func(e: Variant) -> bool: return e is EnemyData)
	if busy or list.is_empty():
		return
	var scene := get_tree().current_scene
	var player := get_tree().get_first_node_in_group("player") as Node2D
	GameState.pending_battle = {
		"enemies": list,
		"encounter_id": encounter_id,
		"return_scene": scene.scene_file_path,
		"return_position": player.global_position if player else Vector2.ZERO,
		"start_hp": GameState.hp,
		"start_casimir_hp": GameState.casimir_hp,
		"backdrop": backdrop,
	}
	change_to(BATTLE_SCENE)


func return_from_battle() -> void:
	var b := GameState.pending_battle
	change_to(b.get("return_scene", VILLAGE_SCENE), "", b.get("return_position", null))


func retry_battle() -> void:
	GameState.set_hp(GameState.pending_battle.get("start_hp", GameState.HERO.max_hp))
	GameState.set_member_hp(&"casimir", GameState.pending_battle.get("start_casimir_hp", GameState.CASIMIR.max_hp))
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

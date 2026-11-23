class_name OverworldEnemy
extends Area2D

@export var data: EnemyData
@export var encounter_id: String = ""
@export var group_pool: Array[EnemyData] = []
@export var look: Texture2D
@export var look_scale: float = 1.0
@export var rustle: bool = false
@export var respawn_seconds: float = 0.0

@onready var _sprite: Sprite2D = $Sprite2D

var _triggered: bool = true
var _anim_time: float = 0.0
var _animated: bool = false


func _ready() -> void:
	if GameState.is_defeated(encounter_id):
		if respawn_seconds <= 0.0:
			queue_free()
			return
		var wait := respawn_seconds - GameState.seconds_since_defeat(encounter_id)
		if wait > 0.0:
			hide()
			await get_tree().create_timer(wait).timeout
		GameState.forget_defeat(encounter_id)
		show()
	if look:
		_sprite.texture = look
		_sprite.scale = Vector2.ONE * look_scale
		_sprite.offset.y = -look.get_height() * 0.5 + 8.0 / look_scale
	elif data and data.sprite_sheet:
		_sprite.texture = data.sprite_sheet
		_sprite.hframes = data.hframes
		_sprite.vframes = data.vframes
		_animated = true
	else:
		_sprite.hide()
		$Placeholder.show()
	if rustle:
		_start_rustle()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	while SceneManager.busy:
		await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	_triggered = get_overlapping_bodies().any(func(b: Node) -> bool: return b.is_in_group("player"))


func _process(delta: float) -> void:
	if not _animated:
		return
	_anim_time += delta
	_sprite.frame = int(_anim_time * 6.0) % _sprite.hframes


func _start_rustle() -> void:
	var t := create_tween().set_loops()
	t.tween_interval(randf_range(1.0, 2.0))
	for x: float in [1.0, -1.0, 1.0, 0.0]:
		t.tween_property(_sprite, "position:x", x, 0.06)


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player") and visible:
		_triggered = false


func _on_body_entered(body: Node) -> void:
	if _triggered or not visible or SceneManager.busy or not body.is_in_group("player"):
		return
	_triggered = true
	set_deferred("monitoring", false)
	var group: Array = [data]
	if not group_pool.is_empty():
		for i in randi_range(0, 2):
			group.append(group_pool.pick_random())
	SceneManager.start_battle(group, encounter_id)

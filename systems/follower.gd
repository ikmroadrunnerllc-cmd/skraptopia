class_name Follower
extends Node2D

const SHEET := "res://assets/characters/ninja_adventure/Character/Knight/SpriteSheet.png"
const GAP := 18.0

var target: Node2D
var _trail: Array[Vector2] = []
var _sprite: Sprite2D
var _dir: int = 0
var _step: float = 0.0


func _ready() -> void:
	name = "CasimirFollower"
	_sprite = Sprite2D.new()
	_sprite.texture = load(SHEET)
	_sprite.hframes = 4
	_sprite.vframes = 7
	_sprite.position = Vector2(0, -8)
	add_child(_sprite)
	if target:
		global_position = target.global_position + Vector2(0, -2)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	var p := target.global_position
	if _trail.is_empty() or _trail[-1].distance_to(p) > 1.0:
		_trail.append(p)
	var moved := false
	while _trail.size() > 1 and _trail[0].distance_to(p) > GAP:
		var next: Vector2 = _trail.pop_front()
		_face(next - global_position)
		global_position = next
		moved = true
	if global_position.distance_to(p) > 120.0:
		global_position = p
		_trail.clear()
	if moved:
		_step += delta * 8.0
	else:
		_step = 0.0
	_sprite.frame = _dir + 4 * (int(_step) % 4)


func _face(d: Vector2) -> void:
	if d.length() < 0.1:
		return
	if absf(d.x) > absf(d.y):
		_dir = 3 if d.x > 0 else 2
	else:
		_dir = 0 if d.y > 0 else 1

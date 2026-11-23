class_name SteppingStones
extends Node2D

@export var points: PackedVector2Array = []
@export var reach: float = 10.0
@export var hop_time: float = 0.28

var _at: int = -1
var _hopping: bool = false


func _physics_process(_delta: float) -> void:
	if _hopping or points.size() < 2:
		return
	var player := get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	var on_rock := _at > 0 and _at < points.size() - 1
	if not on_rock:
		_at = _nearest_end(player)
		if _at < 0:
			return
	if GameState.is_locked() and not on_rock:
		return
	var dir := Input.get_vector("ControllerLeftMovement", "ControllerRightMovement", "ControllerUpMovement", "ControllerDownMovement")
	if dir == Vector2.ZERO:
		return
	for next in [_at - 1, _at + 1]:
		if next < 0 or next >= points.size():
			continue
		if dir.dot((points[next] - points[_at]).normalized()) > 0.6:
			_hop(player, next)
			return


func _nearest_end(player: Node2D) -> int:
	for i in [0, points.size() - 1]:
		if player.global_position.distance_to(to_global(points[i])) <= reach:
			return i
	return -1


func _hop(player: CharacterBody2D, next: int) -> void:
	_hopping = true
	GameState.lock(&"hop")
	var shape := player.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape:
		shape.set_deferred("disabled", true)
	player.Last_Direction = (points[next] - points[_at]).normalized()
	var sprite := player.get_node("AnimatedSprite2D") as Node2D
	var base_y := sprite.position.y
	var t := create_tween().set_parallel()
	t.tween_property(player, "global_position", to_global(points[next]), hop_time)
	t.tween_property(sprite, "position:y", base_y - 6.0, hop_time * 0.5).set_ease(Tween.EASE_OUT)
	t.chain().tween_property(sprite, "position:y", base_y, hop_time * 0.5).set_ease(Tween.EASE_IN)
	await t.finished
	$Splash.play()
	_at = next
	_hopping = false
	if next == 0 or next == points.size() - 1:
		if shape:
			shape.set_deferred("disabled", false)
		GameState.unlock(&"hop")

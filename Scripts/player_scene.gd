extends CharacterBody2D

const SPEED = 120.0

var Idle_Timer: float = 0.0
const Idle_Timer_THRESHOLD: float = 3.0
var Special_Animation = false
var Last_Direction: Vector2 = Vector2.RIGHT

## Interactables (NPCs) whose interaction zone the player is standing in. Only the closest one responds.
var _nearby: Array[Node2D] = []
var _focused: Node2D = null

@onready var animated_sprite = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("player")
	_apply_camera_limits()


func _physics_process(delta: float) -> void:
	Movement_Process(delta)
	move_and_slide()
	_update_focus()


func Movement_Process(delta: float) -> void:
	var Get_Direction := Vector2.ZERO
	if not GameState.is_locked():   # dialogue, menu, battle or scene change blocks movement
		Get_Direction = Input.get_vector("ControllerLeftMovement", "ControllerRightMovement", "ControllerUpMovement", "ControllerDownMovement")

	if Get_Direction != Vector2.ZERO:
		velocity = Get_Direction * SPEED
		Last_Direction = Get_Direction   # remember which way we're facing
	else:
		velocity = Vector2.ZERO

	play_animation(Get_Direction, delta, Last_Direction)


func play_animation(dir: Vector2, delta: float, last_dir: Vector2) -> void:
	# ---------- MOVING ----------
	if dir != Vector2.ZERO:
		Idle_Timer = 0.0
		Special_Animation = false

		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				animated_sprite.play("Walking_Right")
			else:
				animated_sprite.play("Walking_Left")
		else:
			if dir.y < 0:
				animated_sprite.play("Walking_Up")
			else:
				animated_sprite.play("Walking_Down")
		return


	if Special_Animation:
		return

	if abs(last_dir.x) > abs(last_dir.y):
		if last_dir.x > 0:
			animated_sprite.animation = "Walking_Right"
		else:
			animated_sprite.animation = "Walking_Left"
	else:
		if last_dir.y < 0:
			animated_sprite.animation = "Walking_Up"
		else:
			animated_sprite.animation = "Walking_Down"

	animated_sprite.stop()
	animated_sprite.frame = 0

	Idle_Timer += delta
	if Idle_Timer >= Idle_Timer_THRESHOLD:
		Special_Animation = true
		animated_sprite.play("Idle_Animation")


# ---------- INTERACTION ----------

func add_interactable(node: Node2D) -> void:
	if node not in _nearby:
		_nearby.append(node)


func remove_interactable(node: Node2D) -> void:
	_nearby.erase(node)


func _update_focus() -> void:
	var best: Node2D = null
	if not GameState.is_locked():
		var best_dist := INF
		for n in _nearby:
			var d := global_position.distance_squared_to(n.global_position)
			if d < best_dist:
				best_dist = d
				best = n
	if best != _focused:
		if is_instance_valid(_focused):
			_focused.set_prompt_visible(false)
		_focused = best
		if _focused:
			_focused.set_prompt_visible(true)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not event.is_echo() and not GameState.is_locked() and _focused:
		get_viewport().set_input_as_handled()
		_focused.interact(self)


## Each level root can carry metadata "camera_limits" (Rect2i in pixels).
func _apply_camera_limits() -> void:
	var cam := get_node_or_null("Camera2D") as Camera2D
	var level := get_tree().current_scene if get_tree() else null
	if cam == null or level == null or not level.has_meta("camera_limits"):
		return
	var r: Rect2i = level.get_meta("camera_limits")
	cam.limit_left = r.position.x
	cam.limit_top = r.position.y
	cam.limit_right = r.end.x
	cam.limit_bottom = r.end.y

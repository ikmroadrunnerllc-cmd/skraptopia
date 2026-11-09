extends CharacterBody2D

const SPEED = 120.0

var Idle_Timer: float = 0.0
const Idle_Timer_THRESHOLD: float = 3.0
var Special_Animation = false
var Last_Direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	Movement_Process(delta)
	move_and_slide()


func Movement_Process(delta: float) -> void:
	var Get_Direction := Input.get_vector("ControllerLeftMovement", "ControllerRightMovement", "ControllerUpMovement", "ControllerDownMovement")

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

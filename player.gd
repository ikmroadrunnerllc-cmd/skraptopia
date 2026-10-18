extends CharacterBody2D


const SPEED = 80.0


func _physics_process(_delta: float) -> void:
	# Top-down 4-way movement (no gravity, no jump).
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()

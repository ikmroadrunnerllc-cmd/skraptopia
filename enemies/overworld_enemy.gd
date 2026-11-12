class_name OverworldEnemy
extends Area2D

@export var data: EnemyData
@export var encounter_id: String = ""

@onready var _sprite: Sprite2D = $Sprite2D

var _triggered: bool = false
var _anim_time: float = 0.0


func _ready() -> void:
	if GameState.is_defeated(encounter_id):
		queue_free()
		return
	if data and data.sprite_sheet:
		_sprite.texture = data.sprite_sheet
		_sprite.hframes = data.hframes
		_sprite.vframes = data.vframes
	else:
		_sprite.hide()
		$Placeholder.show()
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if _sprite.texture == null:
		return
	_anim_time += delta
	_sprite.frame = int(_anim_time * 6.0) % _sprite.hframes


func _on_body_entered(body: Node) -> void:
	if _triggered or SceneManager.busy or not body.is_in_group("player"):
		return
	_triggered = true
	set_deferred("monitoring", false)
	SceneManager.start_battle(data, encounter_id)

class_name NPC
extends CharacterBody2D
## Reusable NPC. All content comes from `data` (NPCData); quest flow is generic, driven by QuestData.

@export var data: NPCData

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _zone: Area2D = $InteractionZone
@onready var _prompt: Control = $Prompt


func _ready() -> void:
	_prompt.hide()
	if data and data.sprite_sheet:
		_sprite.texture = data.sprite_sheet
		_face(data.facing)
	else:
		_sprite.hide()
		$Placeholder.show()   # missing art: show a marked placeholder instead of crashing
	_zone.body_entered.connect(func(b: Node) -> void: if b.has_method("add_interactable"): b.add_interactable(self))
	_zone.body_exited.connect(func(b: Node) -> void: if b.has_method("remove_interactable"): b.remove_interactable(self))


func set_prompt_visible(value: bool) -> void:
	_prompt.visible = value


func interact(player: Node2D) -> void:
	if data == null:
		return
	_face_towards(player.global_position)
	var quest := data.quest
	if quest == null:
		await Dialogue.play(data.dialogue, data.display_name)
	else:
		match QuestManager.get_state(quest.id):
			QuestManager.State.NOT_STARTED:
				var choice: int = await Dialogue.play(quest.offer_dialogue, data.display_name)
				if choice == 0:
					QuestManager.accept(quest)
					await _after_close()
					await Dialogue.play(quest.accepted_dialogue, data.display_name)
				elif choice > 0:
					await _after_close()
					await Dialogue.play(quest.declined_dialogue, data.display_name)
			QuestManager.State.ACTIVE:
				await Dialogue.play(quest.active_dialogue, data.display_name)
			QuestManager.State.READY_TO_TURN_IN:
				await Dialogue.play(quest.ready_dialogue, data.display_name)
				QuestManager.complete(quest.id)
			QuestManager.State.COMPLETED:
				await Dialogue.play(quest.completed_dialogue if quest.completed_dialogue else data.dialogue, data.display_name)
	if data:
		_face(data.facing)


func _after_close() -> void:
	while Dialogue.is_active():
		await get_tree().process_frame


func _face_towards(target: Vector2) -> void:
	var d := target - global_position
	if absf(d.x) > absf(d.y):
		_face(3 if d.x > 0 else 2)
	else:
		_face(0 if d.y > 0 else 1)


func _face(direction: int) -> void:
	_sprite.frame = clampi(direction, 0, 3)   # row 0 of the sheet: down, up, left, right

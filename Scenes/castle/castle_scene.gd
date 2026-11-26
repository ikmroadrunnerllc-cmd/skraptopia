extends Node

const QUEST: QuestData = preload("res://data/quests/skrapbook.tres")
const BUTTONS := 100
const TALK := [
	["Asmara", "Welcome to my castle, Demari. Now, tell me everything."],
	["Demari", "I found an old game called SkrapTopia. I pressed Start... and woke up in a forest made of paper."],
	["Casimir", "And then they fought off a Clay Sludge to save me, Your Highness."],
	["Asmara", "Another soul pulled in from the other side... I'm sorry, Demari. That game has trapped many before you."],
	["Asmara", "The only way out is to defeat Yalboa, the Arts n' Krafts Witch. His castle lies far to the south."],
	["Asmara", "To reach it, you'd have to cross the Paper, Cloth and Scrap Metal kingdoms. And crossing a border is no easy thing."],
	["Demari", "Then how am I supposed to get there?"],
	["Asmara", "Leave that to me. With a royal pass, any border will open for..."],
]
const ALARM := [
	["Royal Guard", "Your Highness! Your Highness! The SkrapBook... it's been stolen from your chambers!"],
	["Asmara", "WHAT?! Seal the castle! Search every hall!"],
	["Royal Guard", "At once, Your Highness! I'll... go alert the Battalion!"],
]
const DEAL := [
	["Asmara", "The SkrapBook is one of the Sacred Items. It keeps its owner's memories safe... the one thing Yalboa's magic can't twist."],
	["Asmara", "Demari. Bring it back to me, and I'll guarantee your passage to the next kingdom, with everything you need for the road."],
	["Demari", "Deal. Where do we start?"],
	["Casimir", "Whoever took it can't have gone far. Let's search Block Town."],
	["Asmara", "I'm coming with you. It's my book. Here, take these Buttons for supplies."],
	["", "Received %d Buttons!" % BUTTONS],
	["", "New quest: The Stolen SkrapBook."],
]

@export var asmara_path: NodePath
@export var guard_path: NodePath
@export var throne_spot: Vector2
@export var door_spot: Vector2
@export var guard_stop: Vector2


func _ready() -> void:
	if GameState.has_flag(&"quest_skrapbook"):
		for p: NodePath in [asmara_path, guard_path]:
			var n := get_node_or_null(p)
			if n:
				n.queue_free()
		return
	var guard := get_node_or_null(guard_path) as Node2D
	if guard:
		guard.hide()
	_play.call_deferred()


func _play() -> void:
	while SceneManager.busy:
		await get_tree().process_frame
	GameState.lock(&"cutscene")
	var asmara := get_node_or_null(asmara_path) as Node2D
	var guard := get_node_or_null(guard_path) as Node2D
	if asmara:
		await _walk(asmara, throne_spot, 0.8)
	for line in TALK:
		await _say(line[0], line[1])
	if guard:
		guard.position = door_spot
		guard.show()
		await _walk(guard, guard_stop, 0.5)
	for line in ALARM:
		await _say(line[0], line[1])
	if guard:
		await _walk(guard, door_spot, 0.35)
		guard.queue_free()
	for line in DEAL:
		await _say(line[0], line[1])
	GameState.add_buttons(BUTTONS)
	QuestManager.accept(QUEST)
	GameState.set_flag(&"quest_skrapbook")
	if asmara:
		await _walk(asmara, door_spot, 0.8)
		asmara.queue_free()
	GameState.unlock(&"cutscene")


func _walk(actor: Node2D, to: Vector2, seconds: float) -> void:
	var t := create_tween()
	t.tween_property(actor, "position", to, seconds)
	await t.finished


func _say(speaker: String, text: String) -> void:
	var d := DialogueData.new()
	d.speaker = speaker
	d.lines.append(text)
	await Dialogue.play(d)
	while Dialogue.is_active():
		await get_tree().process_frame

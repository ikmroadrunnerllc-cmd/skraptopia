extends Area2D

const ENCOUNTER := "tutorial_sludge"
const INTRO := [
	["Casimir", "Move, you nasty blob of sludge, I MUST get to the princess!!"],
	["Clay Sludge", "Not a chance, you dweeb!"],
	["", "*attack*"],
	["Casimir", "Oh goodness, great heavens! My arm! My freshly polished arm!"],
	["Clay Sludge", "HAHAHAHA!"],
	["Demari", "STOP! Stop attacking him right now!"],
	["Clay Sludge", "Or what?"],
	["Demari", "Or I'll fight you!"],
]
const THANKS := [
	["Casimir", "Thank you for saving me! Are you traveling by yourself?"],
	["Demari", "Not exactly... I need help. I don't know where I am. And this place is strange."],
	["Casimir", "Come with me and I'll take you to Princess Asmara. She'll be able to help you."],
	["Demari", "Oh, thank you!"],
	["Casimir", "It's the least I can do for you saving me."],
	["", "Casimir joined the party!"],
]

@export var sludge_path: NodePath
@export var actor_path: NodePath

var played: bool = false


func _ready() -> void:
	var actor := get_node_or_null(actor_path) as Node2D
	var active := &"casimir" not in GameState.party and not GameState.has_flag(&"casimir_joined")
	if not active:
		if actor:
			actor.queue_free()
		return
	if GameState.is_defeated(ENCOUNTER):
		_thanks.call_deferred()
		return
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if played or not body.is_in_group("player") or SceneManager.busy:
		return
	played = true
	GameState.lock(&"cutscene")
	for line in INTRO:
		if line[0] == "":
			await _attack()
		else:
			await _say(line[0], line[1])
	GameState.unlock(&"cutscene")
	var sludge := get_node_or_null(sludge_path)
	var data: EnemyData = sludge.get("data") if sludge else load("res://data/enemies/clay_sludge.tres")
	SceneManager.start_battle(data, ENCOUNTER)


func _thanks() -> void:
	while SceneManager.busy:
		await get_tree().process_frame
	GameState.lock(&"cutscene")
	for line in THANKS:
		await _say(line[0], line[1])
	GameState.join_party(&"casimir")
	GameState.set_flag(&"casimir_joined")
	var actor := get_node_or_null(actor_path)
	if actor:
		actor.queue_free()
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("spawn_follower"):
		player.spawn_follower()
	GameState.unlock(&"cutscene")


func _say(speaker: String, text: String) -> void:
	var d := DialogueData.new()
	d.speaker = speaker
	d.lines.append(text)
	await Dialogue.play(d)
	while Dialogue.is_active():
		await get_tree().process_frame


func _attack() -> void:
	var sludge := get_node_or_null(sludge_path) as Node2D
	var actor := get_node_or_null(actor_path) as Node2D
	if sludge == null or actor == null:
		return
	var home := sludge.position
	var t := create_tween()
	t.tween_property(sludge, "position", home.lerp(actor.position, 0.6), 0.15)
	t.tween_callback(func() -> void: actor.modulate = Color(1, 0.4, 0.4))
	t.tween_property(actor, "position:x", actor.position.x + 3, 0.05)
	t.tween_property(actor, "position:x", actor.position.x - 3, 0.05)
	t.tween_property(actor, "position:x", actor.position.x, 0.05)
	t.tween_callback(func() -> void: actor.modulate = Color.WHITE)
	t.tween_property(sludge, "position", home, 0.2)
	await t.finished

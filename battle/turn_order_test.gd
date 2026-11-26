extends Control
## Stand-alone test for the turn-order strip. Run this scene (F6).
## Party turns: the strip squishes and the arrow bobs; press Enter/Space (ui_accept) to end the turn.
## Enemy turns pass by themselves after a short wait.

const SWORD: Texture2D = preload("res://assets/ui/kyrise/sword_01a.png")
const FIRE: Texture2D = preload("res://assets/ui/ninja_adventure/Skill Icon/Spell/BookFire.png")

@onready var turnOrder: TurnOrderBar = $TurnOrder

var waitingForInput := false


func _ready() -> void:
	var demari := {"name": "Demari", "isMember": true, "portrait": FramePortrait(load("res://assets/characters/party/demari/demari_frames.tres"), &"Walking_Down")}
	var casimir := {"name": "Casimir", "isMember": true, "portrait": FramePortrait(load("res://assets/characters/party/casimir/casimir_frames.tres"), &"Walking_Down")}
	var slime := Foe("res://data/enemies/slime.tres")
	var spider := Foe("res://data/enemies/frost_spider.tres")
	var orc := Foe("res://data/enemies/mecha_orc_knight.tres")
	# Slime and orc telegraph a plain attack; the spider warns ("!") first, then charges a spell.
	turnOrder.SetOrder([
		{"battler": demari}, {"battler": slime, "charge": {"icon": SWORD}},
		{"battler": casimir}, {"battler": spider, "intent": true},
		{"battler": orc, "charge": {"icon": SWORD}},
		{"battler": demari}, {"battler": spider, "charge": {"icon": FIRE}},
		{"battler": casimir}, {"battler": slime},
		{"battler": demari}, {"battler": orc}, {"battler": casimir},
	])
	turnOrder.Open()
	await get_tree().create_timer(0.6).timeout
	NextTurn()


func NextTurn() -> void:
	if turnOrder.views[0].battler.isMember:
		waitingForInput = true
		turnOrder.SetMemberInput(true)
	else:
		await get_tree().create_timer(0.8).timeout
		turnOrder.Advance()
		NextTurn()


func _unhandled_input(event: InputEvent) -> void:
	if waitingForInput and event.is_action_pressed("ui_accept"):
		waitingForInput = false
		turnOrder.SetMemberInput(false)
		turnOrder.Advance()
		get_viewport().set_input_as_handled()
		await get_tree().create_timer(0.4).timeout
		NextTurn()


func Foe(path: String) -> Dictionary:
	var data: EnemyData = load(path)
	var portrait := data.portrait
	if portrait == null:
		portrait = FramePortrait(data.frames, data.frames.get_animation_names()[0])
	return {"name": data.display_name, "isMember": false, "portrait": portrait}


## First frame of an animation, cropped to a square around the head (same idea as battle.gd _portrait).
func FramePortrait(frames: SpriteFrames, anim: StringName) -> Texture2D:
	var tex := frames.get_frame_texture(anim, 0)
	if not tex is AtlasTexture:
		return tex
	var r: Rect2 = tex.region
	var side := minf(r.size.x, r.size.y)
	var out := AtlasTexture.new()
	out.atlas = tex.atlas
	out.region = Rect2(r.position.x + (r.size.x - side) / 2.0, r.position.y, side, side)
	return out

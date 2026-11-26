class_name TurnOrderBar
extends Control
## Turn-order bar: a strip of portrait frames along the bottom, sliding between 36px slots.
## Laid out for the game's 640x360 screen. Node origin is the centre of the first slot.

const SLOT_WIDTH := 36
const SLOT_OFFSET_X := 18
const MAX_SLOTS := 12
const FRAME_SIZE := Vector2(32, 32)
const TALL_EXTRA := 8   ## the front / choosing frame grows this many px upward
const PORTRAIT_SIZE := 24
const TINT_MEMBER := Color(0.75, 0.88, 1.0)
const TINT_MONSTER := Color(1.0, 0.72, 0.72)
const TINT_PREVIEW := Color(1.0, 0.55, 0.3)   ## monster telegraphing an attack
const TINT_INPUT := Color(1.0, 0.85, 0.35)     ## member choosing a command

@export var frameTexture: Texture2D = preload("res://assets/ui/retro_inventory/Inventory_Slot_1.png")
@export var inputIndicatorTexture: Texture2D = preload("res://assets/ui/ninja_adventure/Arrow.png")
@export var intentBubbleTexture: Texture2D = preload("res://assets/ui/ninja_adventure/Emote/emote22.png")

@onready var strip: NinePatchRect = $Strip
@onready var nextLabel: Label = $NextLabel
@onready var itemLayer: Control = $Items

var visibility := 0.0
var bgOpacity := 0.0       ## strip emphasis while a member is choosing
var isSquished := false    ## command window open -> everything shifts 2 slots right
var memberInput := false   ## a party member is choosing a command
var views: Array[Dictionary] = []  ## {entry, battler, node, xPos, inputRate, chargeRate, intentRate}
var homeY := 0.0
var tweens := {}


func _ready() -> void:
	homeY = position.y
	_process(0)


func Open() -> void:
	TweenProperty(self, "visibility", 1.0, 5 * BattleStyle.FRAME, "visibility")


## New entries start at slot 12 (off the right edge) and slide in.
## Each entry is a battler dict {portrait: Texture2D, isMember: bool}, or {battler, charge: {icon: Texture2D}, intent: bool}:
##  charge = ability being charged / about to execute (ability icon beside the frame),
##  intent = monster telegraphing an attack ("!" bubble + orange frame).
func SetOrder(entries: Array) -> void:
	for view in views:
		view.node.queue_free()
	views.clear()
	for entry in entries:
		views.append(CreateView(entry if entry.has("battler") else {"battler": entry}))
	Retarget()


## Front battler finished its turn: drop it and queue its next turn at the back.
func Advance() -> void:
	var done: Dictionary = views.pop_front()
	done.node.queue_free()
	views.append(CreateView(done.entry))
	Retarget()


func SetMemberInput(active: bool) -> void:
	memberInput = active
	isSquished = active
	TweenProperty(self, "bgOpacity", 1.0 if active else 0.0, 10 * BattleStyle.FRAME, "bg")
	if not views.is_empty():
		TweenProperty(views[0], "inputRate", 1.0 if active else 0.0, 8 * BattleStyle.FRAME, "input")
	Retarget()


func CreateView(entry: Dictionary) -> Dictionary:
	var battler: Dictionary = entry.battler
	var node := Control.new()
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var frame := NinePatchRect.new()
	frame.name = "Frame"
	frame.texture = frameTexture
	frame.patch_margin_left = 4
	frame.patch_margin_top = 4
	frame.patch_margin_right = 4
	frame.patch_margin_bottom = 4
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(frame)
	for nodeName in ["PortraitShadow", "Portrait"]:
		var rect := TextureRect.new()
		rect.name = nodeName
		rect.texture = battler.portrait
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		node.add_child(rect)
	node.get_node("PortraitShadow").self_modulate = BattleStyle.SHADOW_COLOR
	var indicator := TextureRect.new()
	indicator.name = "InputIndicator"
	indicator.texture = inputIndicatorTexture
	indicator.pivot_offset = inputIndicatorTexture.get_size() / 2.0
	indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(indicator)
	# Ability icon at the frame's top-left, with a 1px drop shadow.
	var charge := Control.new()
	charge.name = "ChargeBubble"
	charge.position = Vector2(-22, -26)
	charge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(charge)
	if entry.get("charge") != null:
		for i in 2:
			var icon := TextureRect.new()
			icon.texture = entry.charge.icon
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.size = Vector2(14, 14)
			icon.position = Vector2(1, 1) if i == 0 else Vector2.ZERO
			icon.self_modulate = BattleStyle.SHADOW_COLOR if i == 0 else Color.WHITE
			icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			charge.add_child(icon)
	var intent := TextureRect.new()
	intent.name = "IntentBubble"
	intent.texture = intentBubbleTexture
	intent.position = Vector2(-22, -26)
	intent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(intent)
	itemLayer.add_child(node)
	var view := {"entry": entry, "battler": battler, "node": node, "xPos": float(MAX_SLOTS),
		"inputRate": 0.0, "chargeRate": 0.0, "intentRate": 0.0}
	# Bubbles fade in over ~8 frames.
	var id := node.get_instance_id()
	if entry.get("charge") != null:
		TweenProperty(view, "chargeRate", 1.0, 8 * BattleStyle.FRAME, "charge%d" % id)
	if entry.get("intent", false):
		TweenProperty(view, "intentRate", 1.0, 8 * BattleStyle.FRAME, "intent%d" % id)
	return view


## Each entry eases toward its slot (shifted 2 slots right while the command window is open).
func Retarget() -> void:
	for order in views.size():
		var view := views[order]
		var target := minf(order + (2 if isSquished else 0), MAX_SLOTS)
		TweenProperty(view, "xPos", target, 0.4, "x%d" % view.node.get_instance_id())
		itemLayer.move_child(view.node, 0)  # draw back-to-front: order 0 ends up on top


func TweenProperty(target: Variant, property: String, value: float, duration: float, key: String) -> void:
	if tweens.has(key):
		tweens[key].kill()
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if target is Dictionary:
		tween.tween_method(SetDictValue.bind(target, property), float(target[property]), value, duration)
	else:
		tween.tween_property(target, property, value, duration)
	tweens[key] = tween


func SetDictValue(value: float, target: Dictionary, property: String) -> void:
	target[property] = value


func _process(_delta: float) -> void:
	modulate.a = visibility
	position.y = homeY + int(4.0 * (1.0 - visibility))
	# Background strip spans the full screen width and grows 28 -> 40 px while a member chooses.
	var stripHeight := 28 + int(12.0 * bgOpacity)
	strip.position = Vector2(-position.x, -stripHeight / 2 - 2)
	strip.size = Vector2(get_viewport_rect().size.x, stripHeight)
	strip.modulate.a = 0.6 + bgOpacity * 0.4
	nextLabel.position = Vector2(-FRAME_SIZE.x / 2 - nextLabel.size.x - 4, -nextLabel.size.y / 2)
	nextLabel.modulate = Color(BattleStyle.COLOR_BASE, 1.0 - bgOpacity)
	for order in views.size():
		UpdateView(views[order], order)


func UpdateView(view: Dictionary, order: int) -> void:
	var node: Control = view.node
	var battler: Dictionary = view.battler
	node.visible = view.xPos < 11.999
	node.position = Vector2(int(view.xPos * SLOT_WIDTH + SLOT_OFFSET_X - SLOT_WIDTH / 2), 0)
	node.modulate.a = clampf(MAX_SLOTS - view.xPos, 0.0, 1.0)
	var inputActive: bool = memberInput and view.inputRate > 0.0
	var tall := inputActive or (not memberInput and order == 0)
	var extra := TALL_EXTRA if tall else 0
	var frame: NinePatchRect = node.get_node("Frame")
	frame.position = Vector2(-FRAME_SIZE.x / 2, -FRAME_SIZE.y / 2 - extra)
	frame.size = FRAME_SIZE + Vector2(0, extra)
	if inputActive:
		frame.self_modulate = TINT_INPUT
	elif battler.isMember:
		frame.self_modulate = TINT_MEMBER
	else:
		frame.self_modulate = TINT_PREVIEW if view.intentRate > 0.0 else TINT_MONSTER
	# Portrait fills the frame; the front one is drawn a little larger.
	var side := PORTRAIT_SIZE + extra
	var dst := Rect2(-side / 2, -side / 2 - extra / 2, side, side)
	var portrait: TextureRect = node.get_node("Portrait")
	var shadow: TextureRect = node.get_node("PortraitShadow")
	portrait.position = dst.position
	portrait.size = dst.size
	shadow.position = dst.position + Vector2(1, 1)
	shadow.size = dst.size
	var indicator: TextureRect = node.get_node("InputIndicator")
	indicator.position = Vector2(-indicator.size.x / 2, frame.position.y - indicator.size.y - 1 + BattleStyle.MenuAnimOffset() / 4)
	indicator.modulate.a = view.inputRate
	node.get_node("ChargeBubble").modulate.a = view.chargeRate
	node.get_node("IntentBubble").modulate.a = view.intentRate

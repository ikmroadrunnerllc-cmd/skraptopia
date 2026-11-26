class_name TurnOrderBar
extends Control
## Turn-order bar: a strip of portrait frames along the bottom, sliding between 102px slots.
## Node origin is the left edge of the first slot.

const SLOT_WIDTH := 102
const SLOT_OFFSET_X := 54
const MAX_SLOTS := 12
const FRAME_MEMBER := Rect2(0, 0, 128, 96)
const FRAME_MONSTER := Rect2(128, 0, 128, 96)
const FRAME_INPUT := Rect2(128, 96, 128, 96)
const FRAME_PREVIEW := Rect2(0, 96, 128, 96)  ## monster telegraphing an intent

@export var frameTexture: Texture2D = preload("res://GameAssets/UI/TurnOrderFrame.png")
@export var inputIndicatorTexture: Texture2D = preload("res://GameAssets/UI/TurnInputIndicator.png")
@export var chargeBubbleTexture: Texture2D = preload("res://GameAssets/UI/TurnChargeBubble.png")
@export var intentBubbleTexture: Texture2D = preload("res://GameAssets/UI/TurnIntentBubble.png")

@onready var strip: NinePatchRect = $Strip
@onready var nextLabel: TextureRect = $NextLabel
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
## Each entry is a battler dict, or {battler, charge: {icon, iconIndex}, intent: bool}:
##  charge = ability being charged / about to execute (CT bubble + ability icon),
##  intent = monster telegraphing a charged ability (intent bubble + preview frame).
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
	frame.patch_margin_top = 16      # tall frame repeats rows 16..47
	frame.patch_margin_bottom = 48
	frame.axis_stretch_vertical = NinePatchRect.AXIS_STRETCH_MODE_TILE
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(frame)
	var atlas := AtlasTexture.new()
	atlas.atlas = battler.portrait
	for nodeName in ["PortraitShadow", "Portrait"]:
		var rect := TextureRect.new()
		rect.name = nodeName
		rect.texture = atlas
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_SCALE
		rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # crisp pixel art
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		node.add_child(rect)
	node.get_node("PortraitShadow").self_modulate = BattleStyle.SHADOW_COLOR
	var indicator := TextureRect.new()
	indicator.name = "InputIndicator"
	indicator.texture = inputIndicatorTexture
	indicator.position = Vector2(-48, -34)   # centred above the frame
	indicator.pivot_offset = Vector2(48, 32)
	indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(indicator)
	# Bubbles sit at the frame's top-left, mirrored.
	var charge := TextureRect.new()
	charge.name = "ChargeBubble"
	charge.texture = chargeBubbleTexture
	charge.flip_h = true
	charge.position = Vector2(-54, -10)
	charge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(charge)
	if entry.get("charge") != null:
		# Ability icon inside the bubble, with a 2px drop shadow.
		var region := BattlerPanel.IconRegion(entry.charge.iconIndex)
		charge.add_child(BattlerPanel.SheetRect(entry.charge.icon, region, Vector2(4, 4), BattleStyle.SHADOW_COLOR))
		charge.add_child(BattlerPanel.SheetRect(entry.charge.icon, region, Vector2(2, 2), Color.WHITE))
	var intent := TextureRect.new()
	intent.name = "IntentBubble"
	intent.texture = intentBubbleTexture
	intent.flip_h = true
	intent.position = Vector2(-46, 14)
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
	position.y = homeY + int(10.0 * (1.0 - visibility))
	# Background strip spans the full 1920 width and grows 56 -> 96 px while a member chooses.
	var stripHeight := 56 + int(40.0 * bgOpacity)
	var stripY := 32 - stripHeight / 2
	BattleStyle.FitSkin(strip, BattleStyle.SKIN_BATTLE_PANEL, Vector2(-position.x, stripY), 1920, stripHeight)
	strip.modulate.a = 0.5 + bgOpacity * 0.5
	nextLabel.position = Vector2(-132, stripY + 18)
	nextLabel.modulate = Color(BattleStyle.COLOR_BASE, (1.0 - bgOpacity) * 0.75)
	for order in views.size():
		UpdateView(views[order], order)


func UpdateView(view: Dictionary, order: int) -> void:
	var node: Control = view.node
	var battler: Dictionary = view.battler
	node.visible = view.xPos < 11.999
	node.position = Vector2(int(view.xPos * SLOT_WIDTH + SLOT_OFFSET_X), 0)
	node.modulate.a = clampf(MAX_SLOTS - view.xPos, 0.0, 1.0)
	var inputActive: bool = memberInput and view.inputRate > 0.0
	var tall := inputActive or (not memberInput and order == 0)
	var frame: NinePatchRect = node.get_node("Frame")
	if inputActive:
		frame.region_rect = FRAME_INPUT
	elif battler.isMember:
		frame.region_rect = FRAME_MEMBER
	else:
		frame.region_rect = FRAME_PREVIEW if view.intentRate > 0.0 else FRAME_MONSTER
	frame.position = Vector2(-58, -12 - (16 if tall else 0))
	frame.size = Vector2(128, 128 if tall else 96)
	# Portrait crop: members show the upper body of the standing frame, monsters a window around their focus point.
	var src: Rect2
	var dst: Rect2
	if battler.isMember:
		src = Rect2(0, 7, 32, 30) if tall else Rect2(0, 12, 32, 20)
		dst = Rect2(-50, -15, 96, 90) if tall else Rect2(-50, 0, 96, 60)
	else:
		var h := 46 if tall else 30
		var focus: Vector2 = battler.focus
		src = Rect2(focus.x - 20, focus.y - h / 2, 40, h)
		dst = Rect2(-42, 30 - h, 80, h * 2)
	var portrait: TextureRect = node.get_node("Portrait")
	var shadow: TextureRect = node.get_node("PortraitShadow")
	portrait.texture.region = src
	portrait.position = dst.position
	portrait.size = dst.size
	shadow.position = dst.position + Vector2(2, 2)
	shadow.size = dst.size
	var indicator: TextureRect = node.get_node("InputIndicator")
	indicator.modulate.a = view.inputRate
	indicator.scale.x = BattleStyle.MenuAnim()
	node.get_node("ChargeBubble").modulate.a = view.chargeRate
	node.get_node("IntentBubble").modulate.a = view.intentRate

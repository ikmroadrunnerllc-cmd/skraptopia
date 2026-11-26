class_name BattlerPanel
extends Control
## One party-member or monster card: name, HP/MP/AP gauges, status icons, and panel highlights.
## Node origin is the card's content corner; the panel skins extend around it.

const MEMBER_SIZE := Vector2(100, 50)
const MONSTER_SIZE := Vector2(92, 36)
const STATUS_BASE_COLOR := [Color.TRANSPARENT, Color8(128, 255, 128), Color8(255, 128, 128), Color8(255, 160, 96), Color.TRANSPARENT]  ## none, buff, debuff, stance, strict
const PIP_COLORS := [Color.WHITE, Color(1, 0.843137, 0), Color(0.576471, 0.439216, 0.858824)]  ## turns 1-6, 7-12, 13-18
const MAX_STATUS_ICONS := 6           ## icons visible before scrolling
const STATUS_SCROLL_SECONDS := 1.5    ## time between scroll steps
const ICON_SIZE := 12
const ICON_STEP := 14                 ## px between status icons

@onready var panelBase: NinePatchRect = $PanelBase
@onready var panelActive: NinePatchRect = $PanelActive
@onready var panelSelected: NinePatchRect = $PanelSelected
@onready var nameText: UiText = $NameText
@onready var hpGauge: BattleGauge = $HpGauge
@onready var mpGauge: BattleGauge = $MpGauge
@onready var apGauge: BattleGauge = $ApGauge
@onready var statusText: UiText = $StatusText
@onready var statusIcons: Control = $StatusIcons

var battler: Dictionary
var isMember := true
var bgOpacity := 0.0         ## backdrop while a member is choosing
var inputOpacity := 0.0      ## this battler is choosing a command
var selectionOpacity := 0.0  ## this battler is being targeted
var tweens := {}
var statusScroll := 0.0        ## status icon scroll position, in icons
var statusScrollTarget := 0.0
var statusClock := 0.0


func Setup(data: Dictionary, member: bool) -> void:
	battler = data
	isMember = member
	var contentSize := MEMBER_SIZE if member else MONSTER_SIZE
	size = contentSize
	# Panels cover the content plus a 4px / 3px border.
	for panel: NinePatchRect in [panelBase, panelActive, panelSelected]:
		panel.position = Vector2(-4, -3)
		panel.size = contentSize + Vector2(8, 6)
	panelActive.visible = member
	nameText.text = data.name
	nameText.color = BattleStyle.HpColor(data.hp, data.hpMax, BattleStyle.COLOR_BASE)
	hpGauge.gaugeWidth = int(contentSize.x)
	hpGauge.showMax = member
	hpGauge.ApplyLayout()
	hpGauge.SetValues(data.hp, data.hpMax)
	mpGauge.visible = member
	apGauge.visible = member
	if member:
		mpGauge.SetValues(data.mp, data.mpMax)
		apGauge.SetValues(data.ap, data.apMax)
	statusText.position.y = 38 if member else 24
	statusIcons.position.y = statusText.position.y
	SetStatuses(data.get("statuses", []))
	_process(0)


## statuses: [{icon: Texture2D, category: int (0 None,1 Buff,2 Debuff,3 Stance,4 Strict), count: int, permanent: bool}]
func SetStatuses(statuses: Array) -> void:
	for child in statusIcons.get_children():
		statusIcons.remove_child(child)
		child.queue_free()
	for status in statuses:
		statusIcons.add_child(CreateStatusIcon(status))
	statusText.visible = statuses.is_empty()
	statusScroll = 0.0
	statusScrollTarget = 0.0
	statusClock = 0.0


## Status icon: tinted category square, the icon, and turn-count pips underneath
## (one 1px pip per turn, up to 6; 7-12 turns repaint them gold, 13-18 purple).
func CreateStatusIcon(status: Dictionary) -> Control:
	var node := Control.new()
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var category: int = status.get("category", 0)
	node.add_child(Box(Vector2.ZERO, Vector2(ICON_SIZE, ICON_SIZE), Color(STATUS_BASE_COLOR[category], 0.45 * STATUS_BASE_COLOR[category].a)))
	var icon := TextureRect.new()
	icon.texture = status.icon
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.size = Vector2(ICON_SIZE, ICON_SIZE)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_child(icon)
	if not status.get("permanent", false):
		var count: int = status.get("count", 1)
		var pipY := ICON_SIZE + 1
		node.add_child(Box(Vector2(-1, pipY - 1), Vector2(1 + 2 * mini(count, 6), 3), BattleStyle.SHADOW_COLOR))
		for tier in PIP_COLORS.size():
			var pips := mini(6, count - 6 * tier)
			for p in maxi(pips, 0):
				node.add_child(Box(Vector2(2 * p, pipY), Vector2.ONE, PIP_COLORS[tier]))
	return node


static func Box(pos: Vector2, boxSize: Vector2, tint: Color) -> ColorRect:
	var rect := ColorRect.new()
	rect.position = pos
	rect.size = boxSize
	rect.color = tint
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


## With more than 6 statuses, scroll one icon every 1.5 s, wrapping to the start.
func UpdateStatusScroll(delta: float) -> void:
	var count := statusIcons.get_child_count()
	if count > MAX_STATUS_ICONS:
		statusClock += delta
		if statusClock >= STATUS_SCROLL_SECONDS:
			statusClock = 0.0
			statusScrollTarget += 1.0
			if count < statusScrollTarget + MAX_STATUS_ICONS:
				statusScrollTarget = 0.0
			TweenTo("statusScroll", statusScrollTarget, 0.1)
	# Show max+1 icons from the scroll position; the edge icons fade with the fractional part.
	var first := floori(statusScroll)
	var last := first + MAX_STATUS_ICONS  # inclusive
	var fraction := statusScroll - first
	for i in count:
		var icon: Control = statusIcons.get_child(i)
		icon.visible = i >= first and i <= last
		icon.position.x = int(ICON_STEP * (i - statusScroll))
		icon.modulate.a = 1.0 - fraction if i == first else (fraction if i == last else 1.0)


## Opacity rates are per 60 fps frame.
func SetInputActive(active: bool) -> void:
	TweenTo("inputOpacity", 1.0 if active else 0.0, 0.1 if active else 0.2)


func SetSelected(selected: bool) -> void:
	TweenTo("selectionOpacity", 1.0 if selected else 0.0, 0.1 if selected else 0.2)


func SetBackdrop(visibleNow: bool) -> void:
	TweenTo("bgOpacity", 1.0 if visibleNow else 0.0, 0.1)


func TweenTo(property: String, target: float, perFrame: float) -> void:
	if tweens.has(property):
		tweens[property].kill()
	var duration := absf(target - float(get(property))) / perFrame * BattleStyle.FRAME
	var tween := create_tween()
	tween.tween_property(self, property, target, duration)
	tweens[property] = tween


func _process(delta: float) -> void:
	UpdateStatusScroll(delta)
	panelBase.modulate.a = bgOpacity
	panelActive.modulate.a = inputOpacity
	panelSelected.modulate.a = selectionOpacity * BattleStyle.MenuAnimHighlight()
	statusText.modulate.a = 0.5 + 0.5 * inputOpacity

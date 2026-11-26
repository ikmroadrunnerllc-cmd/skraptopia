class_name BattleCommandWindow
extends Control
## Battle command menu: framed window, four rows with icons, and an animated pointer cursor.
## Node origin is the content corner of a 260 x 168 window (four 42px rows).

signal commandChosen(index: int)
signal enemyInfoRequested
signal turnOrderRequested

const LINE_HEIGHT := 42
const ROW_COUNT := 4

@onready var frame: NinePatchRect = $Frame
@onready var rows: Control = $Rows
@onready var cursor: TextureRect = $Cursor

var items: Array = []  ## [{icon: Texture2D, iconIndex: int, text: String, enabled: bool}]
var selectedIndex := 0
var isOpen := false
var visibility := 0.0     ## open/close fade
var cursorY := 0.0
var cursorOpacity := 0.0
var highlights: Array[float] = [0.0, 0.0, 0.0, 0.0]  ## per-row highlight amount
var homeY := 0.0
var tweens := {}


func _ready() -> void:
	homeY = position.y
	var template := rows.get_child(0)
	for i in range(1, ROW_COUNT):
		var row := template.duplicate()
		row.name = "Row%d" % i
		row.position.y = LINE_HEIGHT * i
		rows.add_child(row)
	BattleStyle.FitSkin(frame, BattleStyle.SKIN_STANDARD, Vector2.ZERO, size.x, LINE_HEIGHT * ROW_COUNT)
	_process(0)


func Setup(commandItems: Array) -> void:
	items = commandItems
	for i in ROW_COUNT:
		var row := rows.get_child(i)
		var item: Dictionary = items[i] if i < items.size() else {}
		var icon: Texture2D = null
		if item.get("icon") != null:
			var atlas := AtlasTexture.new()
			atlas.atlas = item.icon
			var index: int = item.iconIndex
			atlas.region = Rect2(index % 7 * 34 + 2, index / 7 * 34 + 2, 32, 32)  # 7-column icon sheet, 34px cells
			icon = atlas
		row.get_node("Icon").texture = icon
		row.get_node("IconShadow").texture = icon
		var label: UiText = row.get_node("Text")
		label.text = item.get("text", "")
		label.color = BattleStyle.COLOR_BASE if item.get("enabled", false) else BattleStyle.COLOR_DISABLED
	selectedIndex = 0
	cursorY = 0.0
	isOpen = true
	# Fade in over ~5 frames.
	TweenTo("visibility", 1.0, 5 * BattleStyle.FRAME)
	TweenTo("cursorOpacity", 1.0, 3 * BattleStyle.FRAME)
	SetHighlight(selectedIndex)


func Close() -> void:
	isOpen = false
	TweenTo("visibility", 0.0, 5 * BattleStyle.FRAME)
	TweenTo("cursorOpacity", 0.0, 3 * BattleStyle.FRAME)


func _unhandled_input(event: InputEvent) -> void:
	if not isOpen:
		return
	if event.is_action_pressed("ui_down"):
		MoveCursor(1)
	elif event.is_action_pressed("ui_up"):
		MoveCursor(-1)
	elif event.is_action_pressed("ui_accept"):
		if items[selectedIndex].get("enabled", false):
			commandChosen.emit(selectedIndex)
	elif event.is_action_pressed("ui_left"):
		enemyInfoRequested.emit()
	elif event.is_action_pressed("ui_right"):
		turnOrderRequested.emit()
	else:
		return
	get_viewport().set_input_as_handled()


func MoveCursor(step: int) -> void:
	selectedIndex = wrapi(selectedIndex + step, 0, items.size())
	# Cursor glides to the new row over ~4 frames.
	TweenTo("cursorY", float(selectedIndex * LINE_HEIGHT), 4 * BattleStyle.FRAME)
	SetHighlight(selectedIndex)


func SetHighlight(index: int) -> void:
	for i in ROW_COUNT:
		var key := "highlight%d" % i
		if tweens.has(key):
			tweens[key].kill()
		var tween := create_tween()
		tween.tween_method(SetRowHighlight.bind(i), highlights[i], 1.0 if i == index else 0.0, 5 * BattleStyle.FRAME)
		tweens[key] = tween


func SetRowHighlight(value: float, row: int) -> void:
	highlights[row] = value


func TweenTo(property: String, target: float, duration: float) -> void:
	if tweens.has(property):
		tweens[property].kill()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, property, target, duration)
	tweens[property] = tween


func _process(_delta: float) -> void:
	modulate.a = visibility
	position.y = homeY + int(10.0 * (1.0 - visibility))  # windows rise 10px while fading in
	for i in ROW_COUNT:
		var row := rows.get_child(i)
		row.position.x = int(highlights[i] * 8.0)
		row.get_node("Highlight").modulate.a = highlights[i]
	# Cursor sits left of the row, vertically centred, bobbing horizontally.
	cursor.position = Vector2(int(-cursor.size.x + BattleStyle.MenuAnimOffset()), int(cursorY + LINE_HEIGHT * 0.5 - 27))
	cursor.modulate.a = cursorOpacity

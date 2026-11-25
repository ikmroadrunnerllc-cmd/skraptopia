extends Control

signal _next

const FIRST_SCENE := "res://Scenes/woods/playroom_woods.tscn"
const BACKDROP := "res://assets/backgrounds/battle_woods.png"
const OPENING: Array[String] = [
	"Demari found a strange old game at a little game shop. It was called SkrapTopia.",
	"Back home, Demari pressed Start. The screen flashed... and pulled them right inside!",
	"Demari woke up in a forest made of paper and toys. A plain notebook lay in the grass nearby.",
]

var page: int = -1
var _menu: ChoiceList
var _title: Control
var _story: Label
var _hint: Label
var _waiting: bool = false
var _art: TextureRect


func _ready() -> void:
	theme = load("res://ui/themes/jrpg_theme.tres")
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.07, 0.12)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	if ResourceLoader.exists(BACKDROP):
		_art = TextureRect.new()
		var art := _art
		art.texture = load(BACKDROP)
		art.set_anchors_preset(Control.PRESET_FULL_RECT)
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.modulate = Color(0.45, 0.45, 0.55)
		art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(art)

	_title = VBoxContainer.new()
	_title.set_anchors_preset(Control.PRESET_FULL_RECT)
	_title.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(_title)
	var name_label := Label.new()
	name_label.text = "SkrapTopia"
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 48)
	name_label.add_theme_color_override("font_color", Color(0.95, 0.76, 0.31))
	name_label.add_theme_color_override("font_outline_color", Color(0.1, 0.06, 0.1))
	name_label.add_theme_constant_override("outline_size", 8)
	_title.add_child(name_label)
	var sub := Label.new()
	sub.text = "Level 1: Toy Box Kingdom"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.add_child(sub)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 24)
	_title.add_child(gap)
	var center := CenterContainer.new()
	_title.add_child(center)
	_menu = ChoiceList.new()
	_menu.vertical = true
	center.add_child(_menu)
	_menu.set_choices(["New Game"])
	_menu.chosen.connect(_on_chosen)

	_story = Label.new()
	_story.set_anchors_preset(Control.PRESET_FULL_RECT)
	_story.offset_left = 80
	_story.offset_right = -80
	_story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_story.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_story.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_story.add_theme_font_size_override("font_size", 16)
	_story.modulate.a = 0.0
	add_child(_story)
	_hint = Label.new()
	_hint.text = "Press confirm"
	_hint.position = Vector2(520, 330)
	_hint.add_theme_font_size_override("font_size", 8)
	_hint.modulate = Color(1, 1, 1, 0)
	add_child(_hint)
	await get_tree().process_frame
	_menu.focus_first()


func _on_chosen(index: int) -> void:
	if index != 0:
		return
	GameState.new_game()
	_title.hide()
	if _art:
		create_tween().tween_property(_art, "modulate:a", 0.0, 0.5)
	for i in OPENING.size():
		page = i
		_story.text = OPENING[i]
		await _fade(_story, 1.0)
		_hint.modulate.a = 0.6
		_waiting = true
		await _next
		_hint.modulate.a = 0.0
		await _fade(_story, 0.0)
	page = OPENING.size()
	SceneManager.change_to(FIRST_SCENE, "Start")


func _fade(node: CanvasItem, alpha: float) -> void:
	var t := create_tween()
	t.tween_property(node, "modulate:a", alpha, 0.5)
	await t.finished


func _unhandled_input(event: InputEvent) -> void:
	if not _waiting or event.is_echo():
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		_waiting = false
		_next.emit()

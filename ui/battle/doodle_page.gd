class_name DoodlePage
extends Control

signal finished(result: Dictionary)

const PAGE := Rect2(150, 28, 340, 254)
const PAPER := Color(0.98, 0.95, 0.86)
const RULE := Color(0.55, 0.7, 0.9, 0.45)
const MARGIN := Color(0.9, 0.4, 0.4, 0.5)
const INK := Color(0.13, 0.18, 0.45)
const GOLD_INK := Color(0.95, 0.72, 0.2)
const GUIDE := Vector2(46, 34)
const JOIN_TIME := 0.4
const MIN_LENGTH := 30.0
const CURSOR_SPEED := 260.0

var ink_time: float = 0.0
var time_left: float = 0.0
var golden: bool = false
var _skills: Array[SkillData] = []
var _shapes: Dictionary = {}
var _guides: Array[Control] = []
var _strokes: Array[PackedVector2Array] = []
var _pen_down: bool = false
var _join_left: float = -1.0
var _started_ms: int = 0
var _timer_on: bool = false
var _ended_ms: int = 0
var _cursor: Vector2 = PAGE.get_center()
var _show_cursor: bool = false
var _done: bool = false


func setup(skills: Array[SkillData], mp: int) -> void:
	_skills = skills
	for s in skills:
		_shapes[s.id] = DoodleRecognizer.templates(s.doodle)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.position = Vector2(PAGE.position.x, PAGE.end.y - GUIDE.y - 22)
	row.size = Vector2(PAGE.size.x, GUIDE.y + 18)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(row)
	for s in skills:
		var box := VBoxContainer.new()
		box.add_theme_constant_override("separation", 0)
		box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var pic := Control.new()
		pic.custom_minimum_size = GUIDE
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.draw.connect(_draw_guide.bind(pic, s))
		box.add_child(pic)
		var name_label := Label.new()
		name_label.text = "%s %d" % [s.display_name.get_slice(" ", 0), s.mp_cost]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 8)
		name_label.add_theme_color_override("font_color", INK)
		box.add_child(name_label)
		row.add_child(box)
		_guides.append(box)
	set_mp(mp)
	position.y = size.y
	var t := create_tween()
	t.tween_property(self, "position:y", 0.0, 0.2)


func set_mp(mp: int) -> void:
	for i in _skills.size():
		_guides[i].modulate.a = 1.0 if _skills[i].mp_cost <= mp else 0.3


func close() -> void:
	_done = true
	var t := create_tween()
	t.tween_property(self, "position:y", size.y, 0.15)
	t.tween_callback(queue_free)


func submit(strokes: Array[PackedVector2Array], seconds: float) -> void:
	var joined := PackedVector2Array()
	var length := 0.0
	for s in strokes:
		joined.append_array(s)
		for i in range(1, s.size()):
			length += s[i - 1].distance_to(s[i])
	if length < MIN_LENGTH:
		return
	var r := DoodleRecognizer.best(joined, _shapes)
	r["seconds"] = seconds
	finished.emit(r)


func _gui_input(event: InputEvent) -> void:
	if _done:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_show_cursor = false
		if event.pressed:
			_pen(true, event.position)
		else:
			_pen(false, event.position)
		accept_event()
	elif event is InputEventMouseMotion and _pen_down:
		_strokes[-1].append(event.position)
		queue_redraw()
		accept_event()


func _input(event: InputEvent) -> void:
	if _done:
		return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if not _timer_on and _strokes.is_empty():
			_done = true
			finished.emit({})


func _process(delta: float) -> void:
	if _done:
		return
	if _timer_on:
		time_left = maxf(time_left - delta, 0.0)
		if time_left <= 0.0 and not _pen_down and _join_left < 0.0:
			_done = true
			finished.emit({"timeout": true})
			return
	var stick := Input.get_vector("ControllerLeftMovement", "ControllerRightMovement", "ControllerUpMovement", "ControllerDownMovement")
	if stick.length() > 0.2:
		_show_cursor = true
		_cursor = (_cursor + stick * CURSOR_SPEED * delta).clamp(PAGE.position, PAGE.end)
		if _pen_down:
			_strokes[-1].append(_cursor)
	if _show_cursor:
		var held := Input.is_action_pressed("interact") or Input.is_action_pressed("ui_accept")
		if held != _pen_down:
			_pen(held, _cursor)
	if _join_left >= 0.0:
		_join_left -= delta
		if _join_left < 0.0:
			var strokes := _strokes
			_strokes = []
			submit(strokes, (_ended_ms - _started_ms) / 1000.0)
	queue_redraw()


func _pen(down: bool, at: Vector2) -> void:
	if down == _pen_down:
		return
	_pen_down = down
	if down:
		if _strokes.is_empty():
			_started_ms = Time.get_ticks_msec()
		if ink_time > 0.0 and not _timer_on:
			_timer_on = true
			time_left = ink_time
		_join_left = -1.0
		_strokes.append(PackedVector2Array([at]))
	else:
		_strokes[-1].append(at)
		_ended_ms = Time.get_ticks_msec()
		_join_left = JOIN_TIME
	queue_redraw()


func _draw() -> void:
	draw_rect(PAGE, PAPER)
	var y := PAGE.position.y + 22.0
	while y < PAGE.end.y - 6.0:
		draw_line(Vector2(PAGE.position.x, y), Vector2(PAGE.end.x, y), RULE, 1.0)
		y += 14.0
	draw_line(Vector2(PAGE.position.x + 24, PAGE.position.y), Vector2(PAGE.position.x + 24, PAGE.end.y), MARGIN, 1.0)
	draw_rect(PAGE, INK, false, 1.0)
	if ink_time > 0.0:
		var frac := time_left / ink_time if _timer_on else 1.0
		draw_rect(Rect2(PAGE.position + Vector2(30, 8), Vector2((PAGE.size.x - 40) * frac, 5)), INK)
	var ink := GOLD_INK if golden else INK
	for s in _strokes:
		if s.size() > 1:
			draw_polyline(s, ink, 3.0, true)
	if _show_cursor:
		draw_circle(_cursor, 3.0, ink)


func _draw_guide(pic: Control, s: SkillData) -> void:
	var pts := PackedVector2Array()
	for stroke: PackedVector2Array in s.doodle:
		pts.append_array(stroke)
	var r := Rect2(pts[0], Vector2.ZERO)
	for p in pts:
		r = r.expand(p)
	var k := (GUIDE.y - 8) / maxf(maxf(r.size.x, r.size.y), 0.001)
	var off := GUIDE / 2.0 - r.get_center() * k
	for stroke: PackedVector2Array in s.doodle:
		var line := PackedVector2Array()
		for p in stroke:
			line.append(p * k + off)
		pic.draw_polyline(line, INK, 1.5, true)
	pic.draw_circle(s.doodle[0][0] * k + off, 2.0, MARGIN)

class_name ChoiceList
extends VBoxContainer
## Reusable keyboard/mouse selection list (dialogue choices, menus, battle commands).
## Emits `chosen` once per set_choices() call, so a held or double key cannot fire twice.

signal chosen(index: int)

var _armed: bool = false


func set_choices(items: Array[String], disabled: Array[int] = []) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var buttons: Array[Button] = []
	for i in items.size():
		var b := Button.new()
		b.text = items[i]
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.disabled = i in disabled
		b.focus_mode = Control.FOCUS_NONE if b.disabled else Control.FOCUS_ALL
		b.pressed.connect(_on_pressed.bind(i))
		b.mouse_entered.connect(func() -> void: if not b.disabled: b.grab_focus())
		add_child(b)
		if not b.disabled:
			buttons.append(b)
	# wrap focus top <-> bottom over enabled buttons only
	for i in buttons.size():
		buttons[i].focus_neighbor_top = buttons[i - 1].get_path()
		buttons[i].focus_neighbor_bottom = buttons[(i + 1) % buttons.size()].get_path()
	_armed = true


func focus_first() -> void:
	for child in get_children():
		if child is Button and not (child as Button).disabled:
			(child as Button).grab_focus()
			return


func disarm() -> void:
	_armed = false


func _on_pressed(index: int) -> void:
	if not _armed:
		return
	_armed = false
	chosen.emit(index)

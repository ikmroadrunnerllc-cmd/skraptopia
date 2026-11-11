class_name StatBar
extends HBoxContainer
## Reusable "HP  [=====]  30/40" row. bar_variation picks the theme colour (HPBar / MPBar).

@export var label_text: String = "HP"
@export var bar_variation: StringName = &"HPBar"

var _bar: ProgressBar
var _value: Label


func _ready() -> void:
	var name_label := Label.new()
	name_label.text = label_text
	name_label.custom_minimum_size.x = 24
	add_child(name_label)
	_bar = ProgressBar.new()
	_bar.theme_type_variation = bar_variation
	_bar.show_percentage = false
	_bar.custom_minimum_size = Vector2(72, 8)
	_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	add_child(_bar)
	_value = Label.new()
	_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_value.custom_minimum_size.x = 44
	add_child(_value)


func set_values(current: int, maximum: int) -> void:
	if _bar == null:
		await ready
	_bar.max_value = maxi(maximum, 1)
	_bar.value = clampi(current, 0, maximum)
	_value.text = "%d/%d" % [maxi(current, 0), maximum]

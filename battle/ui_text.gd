@tool
class_name UiText
extends Control
## Pixel-font text: plain, +2px drop shadow, or 2px outline (5x5 minus corners).
## The node position is the draw origin; with RIGHT/CENTER justify the text ends/centres on it.

enum Render { NONE, SHADOWED, OUTLINED }
enum Justify { LEFT, CENTER, RIGHT }

@export var text := "":
	set(value):
		text = value
		queue_redraw()
@export var font: Font:
	set(value):
		font = value
		queue_redraw()
@export var color := BattleStyle.COLOR_BASE:
	set(value):
		color = value
		queue_redraw()
@export var render := Render.SHADOWED:
	set(value):
		render = value
		queue_redraw()
@export var justify := Justify.LEFT:
	set(value):
		justify = value
		queue_redraw()


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


## String width without the trailing letter spacing.
static func Measure(textFont: Font, value: String) -> float:
	var spacing: int = BattleStyle.FONT_SPACING.get(textFont.resource_path.get_file().get_basename(), 0)
	return textFont.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, FontSize(textFont)).x - spacing


static func FontSize(textFont: Font) -> int:
	if textFont is FontFile and textFont.fixed_size > 0:
		return textFont.fixed_size
	return 8  # PixelOperator8 is drawn at its native 8px


func _draw() -> void:
	if font == null or text.is_empty():
		return
	var x := 0.0
	if justify == Justify.RIGHT:
		x = -Measure(font, text)
	elif justify == Justify.CENTER:
		x = -floorf(Measure(font, text) / 2.0)
	var fontSize := FontSize(font)
	var origin := Vector2(x, font.get_ascent(fontSize))
	match render:
		Render.SHADOWED:
			DrawAt(origin + Vector2(1, 1), Color(BattleStyle.SHADOW_COLOR, color.a), fontSize)
		Render.OUTLINED:
			# 1px outline at 640x360 (all 8 neighbours).
			var outline := Color(BattleStyle.SHADOW_COLOR, color.a if color.a >= 1.0 else color.a / 8.0)
			for i in range(-1, 2):
				for j in range(-1, 2):
					if i != 0 or j != 0:
						DrawAt(origin + Vector2(i, j), outline, fontSize)
	DrawAt(origin, color, fontSize)


func DrawAt(pos: Vector2, tint: Color, fontSize: int) -> void:
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fontSize, tint)

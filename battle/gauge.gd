class_name BattleGauge
extends Control
## HP / MP / AP gauge: shadowed bar, caption, and value text.
## Node origin is the caption's top-left corner.

@export var gaugeWidth := 150
@export var caption := "HP"
@export var gaugeColor := BattleStyle.COLOR_HP_GAUGE
@export var showMax := false  ## "cur / max" instead of just "cur"
@export var isHp := true      ## HP recolours as it drops

@onready var background: NinePatchRect = $Background
@onready var bar: TextureProgressBar = $Bar
@onready var captionText: UiText = $CaptionText
@onready var currentText: UiText = $CurrentText
@onready var slashText: UiText = $SlashText
@onready var maxText: UiText = $MaxText

var currentValue := 0
var maxValue := 1
var displayValue := 0
var valueTween: Tween


func _ready() -> void:
	ApplyLayout()


func ApplyLayout() -> void:
	# 640x360: an 8px text row, with a 4px bar underneath (1px frame, 2px fill).
	background.position = Vector2(0, 9)
	background.size = Vector2(gaugeWidth, 4)
	bar.position = Vector2(1, 10)
	bar.size = Vector2(gaugeWidth - 2, 2)
	captionText.text = caption
	captionText.position = Vector2.ZERO
	slashText.visible = showMax
	maxText.visible = showMax
	if showMax:
		var digits := UiText.Measure(BattleStyle.FONT_BOLD, "999")
		var slashWidth := UiText.Measure(BattleStyle.FONT_STANDARD, "/")
		var slashX := gaugeWidth - digits - floorf(slashWidth / 2) - 2
		var currentX := slashX - floorf(slashWidth / 2) - 2
		currentText.position = Vector2(currentX, 0)
		slashText.position = Vector2(slashX, 0)
		maxText.position = Vector2(gaugeWidth, 0)
	else:
		currentText.position = Vector2(gaugeWidth, 0)
	Refresh()


func SetValues(current: int, maximum: int) -> void:
	currentValue = current
	maxValue = maxi(maximum, 1)
	displayValue = current
	Refresh()


## The number counts toward the new value; the bar eases with it.
func AnimateTo(current: int) -> void:
	currentValue = current
	if valueTween:
		valueTween.kill()
	valueTween = create_tween()
	valueTween.tween_method(SetDisplay, float(displayValue), float(current), 0.5) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func SetDisplay(value: float) -> void:
	displayValue = roundi(value)
	Refresh()


func Refresh() -> void:
	if not is_node_ready():
		return
	var fill := gaugeColor
	var textColor := BattleStyle.COLOR_BASE
	if isHp:
		fill = BattleStyle.HpColor(currentValue, maxValue, gaugeColor)
		textColor = BattleStyle.HpColor(currentValue, maxValue, BattleStyle.COLOR_BASE)
	elif caption == "MP" and currentValue <= 0:
		fill = BattleStyle.COLOR_MP_DEPLETED
		textColor = BattleStyle.COLOR_MP_DEPLETED
	bar.max_value = maxValue
	bar.value = float(displayValue)
	bar.tint_progress = fill
	bar.tint_under = Color(fill, 0.25)
	for label: UiText in [captionText, currentText, slashText, maxText]:
		label.color = textColor
	currentText.text = str(displayValue)
	maxText.text = str(maxValue)

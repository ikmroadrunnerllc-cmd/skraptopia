class_name BattleStyle
## Shared colours, fonts, window-skin metrics and animation helpers for the battle HUD (1920x1080 layout space).

const COLOR_BASE := Color8(255, 255, 231)
const COLOR_DISABLED := Color8(144, 144, 144)
const COLOR_HP_GAUGE := Color8(105, 179, 47)
const COLOR_HP_ALERT := Color8(255, 184, 190)      # HP at or below half
const COLOR_HP_CRITICAL := Color8(255, 99, 105)    # HP at or below a quarter
const COLOR_HP_DEPLETED := Color8(255, 43, 60)
const COLOR_MP_GAUGE := Color8(26, 184, 250)
const COLOR_MP_DEPLETED := Color8(32, 107, 156)
const COLOR_AP := Color8(255, 166, 0)
const COLOR_GUI_SELECTED := Color8(32, 107, 156)
const SHADOW_COLOR := Color8(20, 21, 41)

const FONT_STANDARD: Font = preload("res://assets/ui/brackeys/fonts/PixelOperator8.ttf")
const FONT_BOLD: Font = preload("res://assets/ui/brackeys/fonts/PixelOperator8-Bold.ttf")
const FONT_SMALL: Font = preload("res://assets/ui/brackeys/fonts/PixelOperator8.ttf")

## Letter spacing per font (baked into xadvance, so trailing spacing is removed when measuring).
const FONT_SPACING := {"FontStandard": 2, "FontStandardBold": 3, "FontStandardSmall": 1, "FontStandardSmallBold": 1}

## One frame at 60 fps; animation durations are expressed in frames.
const FRAME := 1.0 / 60.0

## Window skins: [marginWidth, headerHeight, footerHeight, padLeft, padTop, padRight, padBottom]
const SKIN_STANDARD := [32, 74, 32, 16, 0, 16, -2]            # command window
const SKIN_BATTLE_PANEL := [60, 74, 32, -2, -26, -2, -28]     # battler panel / selection highlight
const SKIN_BATTLE_PANEL_ACTIVE := [60, 74, 32, 2, -26, 2, -28]  # active battler panel


## Menu pulse: 0 -> 1 -> 0 over one second, on a shared clock so everything pulses in sync.
static func MenuAnim() -> float:
	var t := fmod(Time.get_ticks_msec() / 1000.0, 1.0)
	return 0.5 - 0.5 * cos(TAU * t)


## Selection highlight brightness: pulses between 1.0 and 0.6.
static func MenuAnimHighlight() -> float:
	return lerpf(1.0, 0.6, MenuAnim())


## Cursor bob: pulses between 0 and -8 px.
static func MenuAnimOffset() -> float:
	return lerpf(0.0, -8.0, MenuAnim())


## HP colour: normal above half, alert above a quarter, critical above zero, depleted at zero.
static func HpColor(current: int, maxValue: int, normal: Color) -> Color:
	if current > maxValue / 2:
		return normal
	if current > maxValue / 4:
		return COLOR_HP_ALERT
	if current > 0:
		return COLOR_HP_CRITICAL
	return COLOR_HP_DEPLETED


## Sizes a NinePatchRect so its content area covers vPos..vPos + (width, height) plus the skin padding.
static func FitSkin(rect: NinePatchRect, skin: Array, vPos: Vector2, width: float, height: float) -> void:
	rect.position = vPos - Vector2(skin[0] + skin[3], skin[1] + skin[4])
	rect.size = Vector2(skin[0] * 2 + width + skin[3] + skin[5], skin[1] + skin[2] + height + skin[4] + skin[6])

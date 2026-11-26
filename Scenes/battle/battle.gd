extends Control

signal target_picked(index: int)

enum State { BATTLE_START, PLAYER_TURN, ACTION_RESOLUTION, ENEMY_TURN, VICTORY, DEFEAT, TARGETING }
enum Command { ATTACK, SKILLS, ITEMS, DEFEND, RUN }

const COMMANDS: Array[String] = ["Attack", "Skills", "Items", "Defend", "Run"]
const STEP_TIME := 0.9
const FALLBACK_ENEMY: EnemyData = preload("res://data/enemies/slime.tres")
const PALETTE: Shader = preload("res://resources/shaders/palette_shift.gdshader")
const FX_PATH := "res://assets/effects/battle/%s.tres"
const BACKDROP_PATH := "res://assets/backgrounds/battle_%s.png"
const BATTLE_MUSIC := "res://assets/audio/game/music/battle.ogg"
const BOSS_MUSIC := {
	&"zephyrion": "res://assets/audio/game/music/boss_zephyrion.mp3",
	&"iron_jaws": "res://assets/audio/game/music/boss_iron_jaws.mp3",
	&"kilnoxx": "res://assets/audio/game/music/boss_kilnoxx.mp3",
	&"captain_crackjack": "res://assets/audio/game/music/boss_captain_crackjack.mp3",
}
const BOSS_FONTS := "res://assets/ui/fonts/bosses/%s.ttf"
const BOSS_RAGE := {
	&"iron_jaws": {
		"line": "Its spring winds tighter!", "font": "NewRocker-Regular", "color": Color(0.16, 0.78, 0.86),
		"special": "Clockwork Frenzy", "both": false,
		"quips": [[&"demari", "A wind-up fish... with anger issues."], [&"casimir", "Who keeps winding that thing?!"]],
	},
	&"kilnoxx": {
		"line": "我が羽よ、燃え上がれ！", "font": "WDXLLubrifontTC-Regular", "color": Color(1.0, 0.47, 0.08),
		"special": "Inferno Wings", "both": true,
		"quips": [[&"demari", "...Does anyone here speak Japanese?"], [&"casimir", "No, but I'm pretty sure it means \"run.\""]],
	},
	&"captain_crackjack": {
		"line": "He blasts off into the air!", "font": "Ewert-Regular", "color": Color(0.9, 0.16, 0.2),
		"special": "Liberty Dash", "both": true,
		"quips": [[&"demari", "Since when do nutcrackers FLY?!"], [&"casimir", "Since when do they have cannons?!"]],
	},
}
const RAGE_ATTACK := 1.3
const QUIP_TIME := 1.6
const RUN_CHANCE := 0.7
const ENEMY_MAX := Vector2(220, 150)
const GROUP_MAX := Vector2(100, 100)
const SLOTS := [
	[Vector2(470, 272)],
	[Vector2(420, 264), Vector2(550, 282)],
	[Vector2(385, 258), Vector2(475, 284), Vector2(565, 262)],
]
const FRONT_MAX := Vector2(150, 130)
const FRONT_GROUP_MAX := Vector2(105, 110)
const FRONT_SLOTS := [
	[Vector2(320, 220)],
	[Vector2(250, 215), Vector2(390, 215)],
	[Vector2(200, 215), Vector2(320, 215), Vector2(440, 215)],
]
const SIDE_PARTY := {&"demari": Vector2(175, 272), &"casimir": Vector2(105, 276), &"asmara": Vector2(58, 244)}
const FRONT_PARTY := {&"demari": [Vector2(128, 272), 2.0], &"casimir": [Vector2(512, 278), 4.0], &"asmara": [Vector2(320, 282), 3.5]}
const ASMARA_FRAMES: SpriteFrames = preload("res://assets/characters/party/asmara/asmara_frames.tres")
const COMMAND_ICONS: Array[Texture2D] = [
	preload("res://assets/ui/kyrise/sword_01a.png"),
	preload("res://assets/ui/kyrise/spellbook_01a.png"),
	preload("res://assets/ui/kyrise/potion_01a.png"),
	preload("res://assets/ui/kyrise/shield_01a.png"),
	preload("res://assets/ui/kyrise/boots_01a.png"),
]
const SLOT_TEX: Texture2D = preload("res://assets/ui/retro_inventory/Inventory_Slot_1.png")
const HEART_FRAME: Texture2D = preload("res://assets/ui/retro_inventory/Health_01.png")
const HP_FILL: Texture2D = preload("res://assets/ui/retro_inventory/Health_01_Bar01.png")
const MP_FILL: Texture2D = preload("res://assets/ui/retro_inventory/Health_01_Bar03.png")
const HINT_KEYS := ["res://assets/ui/ninja_adventure/Input/Keyboard/KeyE.png", "res://assets/ui/ninja_adventure/Input/Keyboard/KeyEscape.png"]
const HINT_PADS := ["res://assets/ui/ninja_adventure/Input/Gamepad/ButtonA/Idle.png", "res://assets/ui/ninja_adventure/Input/Gamepad/ButtonB/Idle.png"]
const STATUS_ICONS := {
	&"poison": "res://assets/ui/ninja_adventure/Skill Icon/Spell/OrbPlant.png",
	&"sleep": "res://assets/ui/ninja_adventure/Skill Icon/Meteo/Moon.png",
	&"def_down": "res://assets/ui/ninja_adventure/Skill Icon/Spell/Downgrade.png",
	&"def_up": "res://assets/ui/ninja_adventure/Skill Icon/Spell/DefenseUpgrade.png",
	&"atk_up": "res://assets/ui/ninja_adventure/Skill Icon/Spell/AttackUpgrade.png",
}
const STATUS_SFX := {&"poison": "poison", &"sleep": "sleep", &"def_down": "debuff", &"def_up": "def_buff", &"atk_up": "march_order"}
const SFX_PATH := "res://assets/audio/game/sfx/%s.wav"
const DEF_DOWN := 1.3
const DEF_UP := 0.7
const GOLD := Color(1, 0.84, 0.35)
const FX_SIZE := 72.0
const STEP_FORWARD := 28.0
const FIZZLE := 0.7
const FAST_TIME := 1.2
const FAST_BONUS := 1.1
const PANEL_SCENE := preload("res://battle/battler_panel.tscn")
const COMMAND_WINDOW := preload("res://battle/command_window.tscn")
const TURN_STRIP: Texture2D = preload("res://assets/ui/ninja_adventure/Theme/Theme Wood/nine_path_bg.png")
const HUD_FONT: FontFile = preload("res://assets/ui/brackeys/fonts/PixelOperator8.ttf")
const OLD_HUD := ["HudBar", "HudShade", "PartyRows", "Commands", "CommandName", "Hints", "EnemyInfo"]
const TURN_SLOTS := 12

@onready var _backdrop: TextureRect = %Backdrop
@onready var _enemy_info: Control = %EnemyInfo
@onready var _party_rows: Control = %PartyRows
@onready var _commands: ChoiceList = %Commands
@onready var _command_name: Label = %CommandName
@onready var _skill_panel: PanelContainer = %SkillPanel
@onready var _skill_list: ChoiceList = %SkillList
@onready var _hints: HBoxContainer = %Hints
@onready var _message: Label = %Message
@onready var _result: PanelContainer = %ResultWindow
@onready var _result_title: Label = %ResultTitle
@onready var _result_text: Label = %ResultText
@onready var _result_choices: ChoiceList = %ResultChoices

var state: State = State.BATTLE_START
var foes: Array[Dictionary] = []
var actor: StringName = &""
var shield_up: bool = false
var buff_turns: int = 0
var guard_turns: int = 0
var charging: bool = false
var charge_target: int = 0
var guarding: Dictionary = {}
var music: AudioStreamPlayer
var _target: int = 0
var _arrow: Polygon2D
var _order: Array[StringName] = []
var _index: int = 0
var _menu: String = "main"
var _menu_skills: Array[SkillData] = []
var _sprites: Dictionary = {}
var _rows: Dictionary = {}
var _rng := RandomNumberGenerator.new()
var _front: bool = false
var _pad: bool = false
var _feather_used: bool = false
var _pages: Array = []
var _items: Array[StringName] = []
var _item_pick: StringName = &""
var _party_icons: Dictionary = {}
var _page: DoodlePage
var _cmd: BattleCommandWindow
var _cmd_disabled: Array[int] = []
var _turn_bar: TurnOrderBar
var _turn_seq: Array[String] = []
var _turn_who: Dictionary = {}   # "p:<id>" / "f:<index>" -> battler dict for the turn strip
var _cards: Dictionary = {}      # same keys -> BattlerPanel
var _card_state: Dictionary = {} # last value sent to each card, so tweens only restart on change
var _foe_turn: int = -1
var _member_input: bool = false


func _ready() -> void:
	GameState.lock(&"battle")
	_result.hide()
	_commands.chosen.connect(_on_command)
	_skill_list.chosen.connect(_on_command)
	_result_choices.chosen.connect(_on_result_choice)
	var asmara: AnimatedSprite2D = %Casimir.duplicate()
	asmara.name = "Asmara"
	asmara.unique_name_in_owner = false
	asmara.sprite_frames = ASMARA_FRAMES
	%Stage.add_child(asmara)
	_sprites = {&"demari": %Demari, &"casimir": %Casimir, &"asmara": asmara}
	_setup_view()
	_play_music()
	_refresh()
	_start()


func _setup_view() -> void:
	var bd := BACKDROP_PATH % GameState.pending_battle.get("backdrop", "woods")
	if ResourceLoader.exists(bd):
		_backdrop.texture = load(bd)
	var list: Array = GameState.pending_battle.get("enemies", [FALLBACK_ENEMY])
	_front = not list.any(func(e: EnemyData) -> bool: return BOSS_RAGE.has(e.id))
	for id: StringName in _sprites:
		var spr: AnimatedSprite2D = _sprites[id]
		spr.visible = id in GameState.party
		if _front:
			spr.position = FRONT_PARTY[id][0]
			spr.scale = Vector2.ONE * FRONT_PARTY[id][1]
			spr.animation = &"Walking_Up"
		else:
			spr.position = SIDE_PARTY[id]
		spr.frame = 0
	for i in GameState.party.size():
		var id := GameState.party[i]
		_rows[id] = _make_row(id, 292 + i * 28)
	_set_hints(false)
	for id: StringName in _sprites:
		var spr: AnimatedSprite2D = _sprites[id]
		var h := spr.sprite_frames.get_frame_texture(spr.animation, 0).get_height() * spr.scale.y
		_party_icons[id] = _icon_box(spr.position + Vector2(-60, -h - 14))
	var counts := {}
	for e: EnemyData in list:
		counts[e.display_name] = counts.get(e.display_name, 0) + 1
	var seen := {}
	for i in list.size():
		var e: EnemyData = list[i]
		var label := e.display_name
		if counts[label] > 1:
			seen[label] = seen.get(label, 0) + 1
			label += " " + "ABC"[seen[label] - 1]
		if _front:
			_add_foe(e, label, FRONT_SLOTS[list.size() - 1][i], (ENEMY_MAX if BOSS_MUSIC.has(e.id) else FRONT_MAX) if list.size() == 1 else FRONT_GROUP_MAX)
		else:
			_add_foe(e, label, SLOTS[list.size() - 1][i], ENEMY_MAX if list.size() == 1 else GROUP_MAX)
	_arrow = Polygon2D.new()
	_arrow.polygon = PackedVector2Array([Vector2(-7, -10), Vector2(7, -10), Vector2(0, 0)])
	_arrow.color = Color(1, 0.9, 0.3)
	_arrow.hide()
	%Stage.add_child(_arrow)
	_build_hud()


## New HUD (res://battle/): party + enemy cards, command menu, turn-order strip.
## The old HUD nodes stay in battle.tscn but are hidden.
func _build_hud() -> void:
	for n: String in OLD_HUD:
		get_node("Hud/" + n).hide()
	var layer := Control.new()
	layer.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Hud.add_child(layer)
	for i in GameState.party.size():
		var id: StringName = GameState.party[i]
		var m := GameState.member(id)
		var key := "p:%s" % id
		_cards[key] = _card(layer, {"name": m.display_name, "hp": GameState.get_hp(id), "hpMax": m.max_hp,
			"mp": GameState.get_mp(id), "mpMax": m.max_mp}, true, Vector2(532, 30 + 62 * i))
		_turn_who[key] = {"portrait": _portrait(id), "isMember": true}
	for i in foes.size():
		var f: Dictionary = foes[i]
		var key := "f:%d" % i
		_cards[key] = _card(layer, {"name": f.label, "hp": f.hp, "hpMax": f.data.max_hp}, false, Vector2(12, 30 + 46 * i))
		var portrait: Texture2D = f.data.portrait if f.data.portrait else f.sprite.sprite_frames.get_frame_texture(&"idle", 0)
		_turn_who[key] = {"portrait": portrait, "isMember": false}
	_turn_bar = TurnOrderBar.new()
	_turn_bar.position = Vector2(150, 338)  # leaves the bottom-left corner for the command menu
	var strip := NinePatchRect.new()
	strip.name = "Strip"
	strip.texture = TURN_STRIP
	strip.patch_margin_left = 4
	strip.patch_margin_top = 4
	strip.patch_margin_right = 4
	strip.patch_margin_bottom = 4
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var next := Label.new()
	next.name = "NextLabel"
	next.text = "NEXT"
	next.add_theme_font_override("font", HUD_FONT)
	next.add_theme_font_size_override("font_size", 8)
	var items := Control.new()
	items.name = "Items"
	items.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for n: Control in [strip, next, items]:
		_turn_bar.add_child(n)
	layer.add_child(_turn_bar)
	_turn_bar.Open()
	_cmd = COMMAND_WINDOW.instantiate()
	_cmd.position = Vector2(26, 282)
	layer.add_child(_cmd)
	_cmd.commandChosen.connect(func(i: int) -> void:
		_cmd.Close()
		_on_command(i))
	# Skill / item lists open in the command menu's corner (the menu closes), growing upward, drawn on top.
	_skill_panel.offset_left = 10
	_skill_panel.offset_right = 190
	_skill_panel.offset_top = 356
	_skill_panel.offset_bottom = 356
	$Hud.move_child(_skill_panel, -1)


func _card(layer: Control, data: Dictionary, member: bool, at: Vector2) -> BattlerPanel:
	var c: BattlerPanel = PANEL_SCENE.instantiate()
	layer.add_child(c)
	c.position = at
	c.Setup(data, member)
	c.SetBackdrop(true)
	return c


func _update_hud() -> void:
	if _turn_bar == null:
		return
	var choosing := state in [State.PLAYER_TURN, State.TARGETING]
	for id: StringName in GameState.party:
		var key := "p:%s" % id
		var c: BattlerPanel = _cards[key]
		var m := GameState.member(id)
		var hp := GameState.get_hp(id)
		_gauge(c.hpGauge, hp, m.max_hp)
		_gauge(c.mpGauge, GameState.get_mp(id), m.max_mp)
		c.nameText.color = BattleStyle.HpColor(hp, m.max_hp, BattleStyle.COLOR_BASE)
		var marks := []
		if hp > 0 and buff_turns > 0:
			marks.append([&"atk_up", buff_turns])
		if hp > 0 and guard_turns > 0:
			marks.append([&"def_up", guard_turns])
		_card_statuses(key, c, marks, 1)
		_card_flag(key + ":input", choosing and id == actor, c.SetInputActive)
	for i in foes.size():
		var key := "f:%d" % i
		var f: Dictionary = foes[i]
		var c: BattlerPanel = _cards[key]
		_gauge(c.hpGauge, f.hp, f.data.max_hp)
		c.nameText.color = BattleStyle.HpColor(f.hp, f.data.max_hp, BattleStyle.COLOR_BASE)
		c.modulate.a = 1.0 if f.hp > 0 else 0.4
		var marks := []
		if f.hp > 0:
			for k: StringName in f.status:
				marks.append([k, f.status[k]])
		_card_statuses(key, c, marks, 2)
		_card_flag(key + ":target", state == State.TARGETING and i == _target, c.SetSelected)
	_sync_turns()


func _gauge(g: BattleGauge, value: int, maximum: int) -> void:
	if g.maxValue != maxi(maximum, 1):
		g.SetValues(value, maximum)
	elif g.currentValue != value:
		g.AnimateTo(value)


func _card_flag(key: String, on: bool, apply: Callable) -> void:
	if _card_state.get(key, false) != on:
		_card_state[key] = on
		apply.call(on)


## marks: [[status key, turns left], ...]; category 1 = buff, 2 = debuff.
func _card_statuses(key: String, c: BattlerPanel, marks: Array, category: int) -> void:
	if _card_state.get(key + ":status") == marks:
		return
	_card_state[key + ":status"] = marks.duplicate(true)
	var list := []
	for mark: Array in marks:
		if STATUS_ICONS.has(mark[0]):
			list.append({"icon": load(STATUS_ICONS[mark[0]]), "category": category, "count": int(mark[1])})
	c.SetStatuses(list)


## Who acts next, as turn-strip keys: the rest of this round, then whole rounds (party, then enemies).
## "*" marks Casimir's charged attack; "!" marks an enemy whose next move is its rage special.
func _turn_keys() -> Array[String]:
	var seq: Array[String] = []
	var party := _alive()
	var living := _living()
	if state in [State.VICTORY, State.DEFEAT] or party.is_empty() or living.is_empty():
		return seq
	if state == State.ENEMY_TURN:
		for i in living:
			if i >= _foe_turn:
				seq.append("f:%d" % i)
	else:
		for k in range(_index, _order.size()):
			if GameState.get_hp(_order[k]) > 0:
				seq.append("p:%s" % _order[k])
		for i in living:
			seq.append("f:%d" % i)
	while seq.size() < TURN_SLOTS:
		for id in party:
			seq.append("p:%s" % id)
		for i in living:
			seq.append("f:%d" % i)
	seq.resize(TURN_SLOTS)
	var marked := {}
	for n in seq.size():
		var key := seq[n]
		if marked.has(key):
			continue
		marked[key] = true
		if key == "p:casimir" and charging:
			seq[n] = key + "*"
		elif key.begins_with("f:") and _rage_next(int(key.substr(2))):
			seq[n] = key + "!"
	return seq


func _rage_next(i: int) -> bool:
	var f: Dictionary = foes[i]
	if not BOSS_RAGE.has(f.data.id):
		return false
	return f.rage_turns % 2 == 0 if f.raging else f.hp * 2 <= f.data.max_hp


func _turn_entry(key: String) -> Dictionary:
	var entry := {"battler": _turn_who[key.trim_suffix("*").trim_suffix("!")]}
	if key.ends_with("*"):
		entry.charge = {"icon": COMMAND_ICONS[Command.ATTACK]}
	if key.ends_with("!"):
		entry.intent = true
	return entry


func _sync_turns() -> void:
	if _turn_bar == null:
		return
	var input := state in [State.PLAYER_TURN, State.TARGETING]
	if not input and _member_input:
		_member_input = false
		_turn_bar.SetMemberInput(false)
	var seq := _turn_keys()
	if seq != _turn_seq:
		if seq.size() == TURN_SLOTS and _turn_seq.size() == TURN_SLOTS and seq.slice(0, TURN_SLOTS - 1) == _turn_seq.slice(1):
			_turn_bar.Advance(_turn_entry(seq[-1]))
		else:
			_turn_bar.SetOrder(seq.map(_turn_entry))
		_turn_seq = seq
	_turn_bar.visible = not seq.is_empty()
	if input and not _member_input:
		_member_input = true
		_turn_bar.SetMemberInput(true)


func _disarm_commands() -> void:
	_commands.disarm()
	if _cmd and _cmd.isOpen:
		_cmd.Close()


func _cmd_items() -> Array:
	var items := []
	for j in COMMANDS.size():
		items.append({"icon": COMMAND_ICONS[j], "text": COMMANDS[j], "enabled": not j in _cmd_disabled})
	return items


func _make_row(id: StringName, y: float) -> Dictionary:
	var slot := TextureRect.new()
	slot.texture = SLOT_TEX
	slot.position = Vector2(16, y)
	_party_rows.add_child(slot)
	var portrait := TextureRect.new()
	portrait.texture = _portrait(id)
	portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portrait.position = Vector2(32, y + 16) - portrait.texture.get_size() / 2.0
	_party_rows.add_child(portrait)
	var name_label := Label.new()
	name_label.text = GameState.member(id).display_name
	name_label.position = Vector2(52, y + 11)
	_party_rows.add_child(name_label)
	return {"name": name_label, "hp": _make_heart_bar(Vector2(100, y + 8), HP_FILL), "mp": _make_heart_bar(Vector2(228, y + 8), MP_FILL)}


func _portrait(id: StringName) -> Texture2D:
	var tex: AtlasTexture = _sprites[id].sprite_frames.get_frame_texture(&"Walking_Down", 0)
	var r := tex.region
	var side := minf(r.size.x, 20.0)
	var out := AtlasTexture.new()
	out.atlas = tex.atlas
	out.region = Rect2(r.position.x + (r.size.x - side) / 2.0, r.position.y + (2.0 if r.size.y > r.size.x else 0.0), side, side)
	return out


func _make_heart_bar(at: Vector2, fill: Texture2D) -> Dictionary:
	var frame := TextureRect.new()
	frame.texture = HEART_FRAME
	frame.position = at
	_party_rows.add_child(frame)
	var fill_tex := AtlasTexture.new()
	fill_tex.atlas = fill
	fill_tex.region = Rect2(16, 0, 45, 16)
	var bar := TextureProgressBar.new()
	bar.texture_progress = fill_tex
	bar.position = at + Vector2(16, 0)
	_party_rows.add_child(bar)
	var value := Label.new()
	value.position = at + Vector2(68, 3)
	_party_rows.add_child(value)
	return {"bar": bar, "value": value}


func _set_heart_bar(b: Dictionary, current: int, maximum: int) -> void:
	b.bar.max_value = maxi(maximum, 1)
	b.bar.value = clampi(current, 0, maximum)
	b.value.text = "%d/%d" % [maxi(current, 0), maximum]


func _add_foe(e: EnemyData, label: String, at: Vector2, max_size: Vector2) -> void:
	var name_label := Label.new()
	name_label.text = label
	name_label.add_theme_color_override("font_color", GOLD)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var bar := ProgressBar.new()
	bar.theme_type_variation = &"EnemyHPBar"
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(60, 4)
	bar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var row := VBoxContainer.new()
	row.add_theme_constant_override("separation", 1)
	row.custom_minimum_size.x = 120
	row.add_child(name_label)
	row.add_child(bar)
	_enemy_info.add_child(row)
	var spr := AnimatedSprite2D.new()
	spr.position = at
	%Stage.add_child(spr)
	var foe := {"data": e, "hp": e.max_hp, "label": label, "sprite": spr, "name": name_label, "bar": bar, "raging": false, "rage_turns": 0, "rest": &"idle", "status": {}}
	foes.append(foe)
	var sf := e.frames
	if sf == null:
		sf = SpriteFrames.new()
		sf.add_animation(&"idle")
		if e.sprite_sheet:
			var at_tex := AtlasTexture.new()
			at_tex.atlas = e.sprite_sheet
			at_tex.region = Rect2(Vector2.ZERO, e.sprite_sheet.get_size() / Vector2(maxi(e.hframes, 1), maxi(e.vframes, 1)))
			sf.add_frame(&"idle", at_tex)
			spr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		else:
			sf.add_frame(&"idle", PlaceholderTexture2D.new())
	spr.sprite_frames = sf
	var first := sf.get_frame_texture(&"idle", 0)
	var k := minf(max_size.x / first.get_width(), max_size.y / first.get_height())
	spr.scale = Vector2(k, k)
	if e.hue_shift != 0.0 or e.saturation != 1.0 or e.brightness != 1.0:
		var m := ShaderMaterial.new()
		m.shader = PALETTE
		m.set_shader_parameter("hue_shift", e.hue_shift)
		m.set_shader_parameter("saturation", e.saturation)
		m.set_shader_parameter("brightness", e.brightness)
		spr.material = m
	spr.frame_changed.connect(_align_enemy.bind(spr))
	spr.animation_finished.connect(func() -> void: if foe.hp > 0: spr.play(foe.rest))
	spr.play(&"idle")
	_align_enemy(spr)
	row.position = at + Vector2(-60, -first.get_height() * k - 22)
	foe.icons = _icon_box(row.position + Vector2(0, -14))


func _icon_box(at: Vector2) -> HBoxContainer:
	var box := HBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 1)
	box.position = at
	box.size = Vector2(120, 12)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_enemy_info.add_child(box)
	return box


func _set_icons(box: HBoxContainer, keys: Array) -> void:
	for c in box.get_children():
		box.remove_child(c)
		c.queue_free()
	for k: StringName in keys:
		var r := TextureRect.new()
		r.texture = load(STATUS_ICONS[k])
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		r.custom_minimum_size = Vector2(12, 12)
		r.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		box.add_child(r)


func _party_status_keys() -> Array:
	var keys := []
	if buff_turns > 0:
		keys.append(&"atk_up")
	if guard_turns > 0:
		keys.append(&"def_up")
	return keys


func _sfx(id: String) -> void:
	var path := SFX_PATH % id
	if not ResourceLoader.exists(path):
		return
	var p := AudioStreamPlayer.new()
	p.stream = load(path)
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()


func _align_enemy(spr: AnimatedSprite2D) -> void:
	var tex := spr.sprite_frames.get_frame_texture(spr.animation, spr.frame)
	if tex:
		spr.offset = Vector2(0, -tex.get_height() / 2.0)


func _enemy_anim(i: int, anim: StringName) -> void:
	var spr: AnimatedSprite2D = foes[i].sprite
	if spr.sprite_frames.has_animation(anim):
		spr.play(anim)


func _play_music() -> void:
	var path := BATTLE_MUSIC
	for f in foes:
		if BOSS_MUSIC.has(f.data.id):
			path = BOSS_MUSIC[f.data.id]
	var lyrics := path.replace(".mp3", "_lyrics.mp3")
	if GameState.boss_music_lyrics and lyrics != path and ResourceLoader.exists(lyrics):
		path = lyrics
	if not ResourceLoader.exists(path):
		return
	var stream: AudioStream = load(path)
	stream.set("loop", true)
	music = AudioStreamPlayer.new()
	music.stream = stream
	music.volume_db = -8.0
	add_child(music)
	music.play()


func _refresh() -> void:
	for i in foes.size():
		var f: Dictionary = foes[i]
		f.bar.max_value = f.data.max_hp
		f.bar.value = f.hp
		f.name.modulate = Color(1.3, 1.3, 1.3) if state == State.TARGETING and i == _target else Color.WHITE
		_set_icons(f.icons, f.status.keys() if f.hp > 0 else [])
	for id: StringName in _party_icons:
		_set_icons(_party_icons[id], _party_status_keys() if GameState.get_hp(id) > 0 and id in GameState.party else [])
	for id: StringName in _rows:
		var m := GameState.member(id)
		_set_heart_bar(_rows[id].hp, GameState.get_hp(id), m.max_hp)
		_set_heart_bar(_rows[id].mp, GameState.get_mp(id), m.max_mp)
		_rows[id].name.modulate = GOLD if id == actor and state in [State.PLAYER_TURN, State.TARGETING] else Color.WHITE
		var spr: AnimatedSprite2D = _sprites[id]
		spr.modulate = Color(0.45, 0.45, 0.45) if GameState.get_hp(id) <= 0 else Color.WHITE
	_update_hud()


func _alive() -> Array[StringName]:
	var out: Array[StringName] = []
	for id in GameState.party:
		if GameState.get_hp(id) > 0:
			out.append(id)
	return out


func _living() -> Array[int]:
	var out: Array[int] = []
	for i in foes.size():
		if foes[i].hp > 0:
			out.append(i)
	return out


func _start() -> void:
	_skill_panel.hide()
	_set_commands([0, 1, 2, 3, 4])
	_disarm_commands()
	await _say(_intro_text())
	var fastest := 0
	for f in foes:
		fastest = maxi(fastest, f.data.speed)
	if fastest > GameState.member(&"demari").speed:
		await _enemy_turn()
	else:
		_begin_round()


func _intro_text() -> String:
	if foes.size() == 1:
		return "A wild %s appears!" % foes[0].label
	var names: Array[String] = []
	for f in foes:
		names.append(f.label)
	return "%s and %s appear!" % [", ".join(PackedStringArray(names.slice(0, -1))), names[-1]]


func _begin_round() -> void:
	if state == State.VICTORY or state == State.DEFEAT:
		return
	_order = _alive()
	_index = 0
	_next_actor()


func _next_actor() -> void:
	if state == State.VICTORY or state == State.DEFEAT:
		return
	if _living().is_empty():
		_victory()
		return
	if _index >= _order.size():
		await _enemy_turn()
		return
	actor = _order[_index]
	if GameState.get_hp(actor) <= 0:
		_index += 1
		_next_actor()
		return
	guarding[actor] = false
	if actor == &"casimir" and charging:
		state = State.ACTION_RESOLUTION
		await _unleash_charge()
		_end_action()
		return
	_show_main_menu()


func _show_main_menu() -> void:
	state = State.PLAYER_TURN
	_menu = "main"
	var disabled: Array[int] = []
	if GameState.inventory.is_empty():
		disabled.append(Command.ITEMS)
	if GameState.skills_for(actor).is_empty():
		disabled.append(Command.SKILLS)
	if actor != &"demari" or not _can_run():
		disabled.append(Command.RUN)
	_message.text = "What will %s do?" % GameState.member(actor).display_name
	_skill_panel.hide()
	_set_commands(disabled)
	_cmd.Setup(_cmd_items())
	_refresh()


func _set_commands(disabled: Array[int]) -> void:
	_cmd_disabled = disabled
	_commands.set_choices(COMMANDS, disabled)
	var slot := StyleBoxTexture.new()
	slot.texture = SLOT_TEX
	var ring := StyleBoxFlat.new()
	ring.draw_center = false
	ring.set_border_width_all(1)
	ring.border_color = Color(1, 0.94, 0.59)
	for j in _commands.get_child_count():
		var b: Button = _commands.get_child(j)
		b.text = ""
		b.icon = COMMAND_ICONS[j]
		b.custom_minimum_size = Vector2(26, 26)
		b.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		b.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		for st in ["normal", "hover", "pressed", "disabled"]:
			b.add_theme_stylebox_override(st, slot)
		b.add_theme_stylebox_override("focus", ring)
		b.add_theme_color_override("icon_disabled_color", Color(1, 1, 1, 0.3))
		b.focus_entered.connect(func() -> void: _command_name.text = COMMANDS[j])


func _can_run() -> bool:
	for f in foes:
		if not f.data.can_run:
			return false
	return true


func _show_skill_menu() -> void:
	state = State.PLAYER_TURN
	_menu = "skills"
	_menu_skills = GameState.skills_for(actor)
	var names: Array[String] = []
	var disabled: Array[int] = []
	for i in _menu_skills.size():
		var s := _menu_skills[i]
		names.append("%s  %dMP" % [s.display_name, s.mp_cost])
		if s.mp_cost > GameState.get_mp(actor):
			disabled.append(i)
	names.append("Back")
	_message.text = _menu_skills[0].description if not _menu_skills.is_empty() else ""
	_disarm_commands()
	_skill_list.set_choices(names, disabled)
	_skill_panel.show()
	_skill_list.focus_first()
	_refresh()


func _show_item_menu() -> void:
	state = State.PLAYER_TURN
	_menu = "items"
	_items.clear()
	var names: Array[String] = []
	for i in GameState.ITEMS:
		if GameState.inventory.get(i.id, 0) > 0:
			_items.append(i.id)
			names.append("%s  x%d" % [i.display_name, GameState.inventory[i.id]])
	names.append("Back")
	_message.text = GameState.item(_items[0]).description if not _items.is_empty() else ""
	_disarm_commands()
	_skill_list.set_choices(names)
	_skill_panel.show()
	_skill_list.focus_first()
	_refresh()


func _show_item_targets() -> void:
	_menu = "item_target"
	var names: Array[String] = []
	for id in GameState.party:
		var m := GameState.member(id)
		names.append("%s  %d/%d HP  %d/%d MP" % [m.display_name, GameState.get_hp(id), m.max_hp, GameState.get_mp(id), m.max_mp])
	names.append("Back")
	_message.text = "Use the %s on who?" % GameState.item(_item_pick).display_name
	_skill_list.set_choices(names)
	_skill_list.focus_first()


func _on_command(index: int) -> void:
	if state != State.PLAYER_TURN:
		return
	if _menu == "items":
		if index >= _items.size():
			_show_main_menu()
			return
		_item_pick = _items[index]
		_show_item_targets()
		return
	if _menu == "item_target":
		if index >= GameState.party.size():
			_show_item_menu()
			return
		var who := GameState.party[index]
		if GameState.get_hp(who) <= 0 and not GameState.item(_item_pick).full_heal:
			_show_item_targets()
			_message.text = "%s is knocked out. Only Bandage Tape can help." % GameState.member(who).display_name
			return
		state = State.ACTION_RESOLUTION
		_skill_panel.hide()
		await _step(actor)
		var text := GameState.use_item(_item_pick, who)
		_sfx("ui/use_item")
		_play_fx(&"sp_magic_burst_green", _center_of(who))
		_refresh()
		await _say(text)
		_end_action()
		return
	if _menu == "skills":
		if index >= _menu_skills.size():
			_show_main_menu()
			return
		var s := _menu_skills[index]
		var t := -1
		if s.kind in ["damage", "charge", "status"] and not s.hits_all:
			t = await _choose_target()
			if t < 0:
				_show_skill_menu()
				return
		state = State.ACTION_RESOLUTION
		await _use_skill(s, t)
		_end_action()
		return
	match index:
		Command.ATTACK:
			var t := await _choose_target()
			if t < 0:
				_show_main_menu()
				return
			state = State.ACTION_RESOLUTION
			await _attack(t)
			_end_action()
		Command.SKILLS:
			if _doodle_skills().is_empty():
				_show_skill_menu()
			else:
				_open_doodle()
		Command.ITEMS:
			_show_item_menu()
		Command.DEFEND:
			state = State.ACTION_RESOLUTION
			guarding[actor] = true
			await _say("%s is defending." % GameState.member(actor).display_name)
			_end_action()
		Command.RUN:
			state = State.ACTION_RESOLUTION
			await _try_run()


func _choose_target() -> int:
	var alive := _living()
	if alive.size() == 1:
		return alive[0]
	if not alive.has(_target):
		_target = alive[0]
	state = State.TARGETING
	_disarm_commands()
	get_viewport().gui_release_focus()
	_show_target()
	var pick: int = await target_picked
	_arrow.hide()
	return pick


func _show_target() -> void:
	var spr: AnimatedSprite2D = foes[_target].sprite
	var tex := spr.sprite_frames.get_frame_texture(spr.animation, spr.frame)
	_arrow.position = spr.position + Vector2(0, -tex.get_height() * spr.scale.y - 26)
	_arrow.show()
	_message.text = "Choose a target: %s" % foes[_target].label
	_refresh()


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or (event is InputEventJoypadMotion and absf(event.axis_value) > 0.5):
		_set_hints(true)
	elif event is InputEventKey:
		_set_hints(false)


func _set_hints(pad: bool) -> void:
	if pad == _pad and _hints.get_child_count() > 0:
		return
	_pad = pad
	for c in _hints.get_children():
		_hints.remove_child(c)
		c.queue_free()
	var icons: Array = HINT_PADS if pad else HINT_KEYS
	for n in 2:
		var icon := TextureRect.new()
		icon.texture = load(icons[n])
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		_hints.add_child(icon)
		var label := Label.new()
		label.text = ["Select", "Back"][n]
		_hints.add_child(label)


func _unhandled_input(event: InputEvent) -> void:
	if state != State.TARGETING:
		return
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up") or event.is_action_pressed("ControllerLeftMovement"):
		_move_target(-1)
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down") or event.is_action_pressed("ControllerRightMovement"):
		_move_target(1)
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		state = State.ACTION_RESOLUTION
		target_picked.emit(_target)
	elif event.is_action_pressed("ui_cancel"):
		state = State.PLAYER_TURN
		target_picked.emit(-1)
	else:
		return
	get_viewport().set_input_as_handled()


func _move_target(step: int) -> void:
	var alive := _living()
	_target = alive[(alive.find(_target) + step + alive.size()) % alive.size()]
	_show_target()


func _end_action() -> void:
	_refresh()
	if state == State.VICTORY or state == State.DEFEAT:
		return
	_index += 1
	_next_actor()


func _attack_power(id: StringName) -> int:
	var a := GameState.member(id).attack
	return int(a * 1.5) if buff_turns > 0 else a


func _foe_damage(i: int, power: float) -> int:
	var dmg := _damage(int(_attack_power(actor) * power), foes[i].data.defense)
	if foes[i].status.has(&"def_down"):
		dmg = int(dmg * DEF_DOWN)
	if GameState.has_key_item(&"steel_fang"):
		dmg = int(dmg * 1.15)
	return maxi(dmg, 1)


func _hit_enemy(i: int, dmg: int, fx: StringName) -> void:
	var f: Dictionary = foes[i]
	f.status.erase(&"sleep")
	f.hp = maxi(f.hp - dmg, 0)
	_play_fx(fx, _enemy_center(i))
	_enemy_anim(i, &"damage")
	_flash(f.sprite)
	_refresh()
	if f.hp <= 0:
		var t := create_tween()
		t.tween_property(f.sprite, "modulate:a", 0.0, 0.6)
		f.name.modulate = Color(0.5, 0.5, 0.5)


func _attack(t: int) -> void:
	await _step(actor)
	var dmg := _foe_damage(t, 1.0)
	_hit_enemy(t, dmg, &"na_cut")
	await _say("%s attacks! %s takes %d damage." % [GameState.member(actor).display_name, foes[t].label, dmg])


func _doodle_skills() -> Array[SkillData]:
	return GameState.skills_for(actor).filter(func(s: SkillData) -> bool: return not s.doodle.is_empty())


func _doodle_mult(score: float, seconds: float) -> float:
	var m := lerpf(0.8, 1.2, clampf((score - FIZZLE) / (1.0 - FIZZLE), 0.0, 1.0))
	return m * (FAST_BONUS if seconds < FAST_TIME else 1.0)


func _open_doodle() -> void:
	var skills := _doodle_skills()
	var t := -1
	if skills.any(func(s: SkillData) -> bool: return s.kind in ["damage", "status"] and not s.hits_all):
		t = await _choose_target()
		if t < 0:
			_show_main_menu()
			return
	state = State.PLAYER_TURN
	_menu = "doodle"
	_disarm_commands()
	get_viewport().gui_release_focus()
	_page = DoodlePage.new()
	add_child(_page)
	_page.setup(skills, GameState.get_mp(actor))
	_message.text = "Draw a skill! (Esc: back)"
	while true:
		var r: Dictionary = await _page.finished
		if r.is_empty():
			_page.close()
			_page = null
			_show_main_menu()
			return
		var s: SkillData = null
		for k in skills:
			if k.id == r.id:
				s = k
		if r.score < FIZZLE:
			_sfx("ui/denied")
			_message.text = "Fizzle... (closest: %s %d%%) Try again!" % [s.display_name, int(r.score * 100)]
			continue
		if s.mp_cost > GameState.get_mp(actor):
			_sfx("ui/denied")
			_message.text = "Not enough MP for %s! Try another." % s.display_name
			continue
		_page.close()
		_page = null
		state = State.ACTION_RESOLUTION
		var fast: bool = r.seconds < FAST_TIME
		await _say("%s! %d%%%s" % [s.display_name, int(r.score * 100), " Fast!" if fast else ""], 0.6)
		var target := t if t >= 0 and foes[t].hp > 0 else (_living()[0] if s.kind in ["damage", "status"] else -1)
		await _use_skill(s, target, _doodle_mult(r.score, r.seconds))
		_end_action()
		return


func _use_skill(s: SkillData, t: int, mult := 1.0) -> void:
	var who := GameState.member(actor).display_name
	GameState.set_member_mp(actor, GameState.get_mp(actor) - s.mp_cost)
	_refresh()
	await _step(actor)
	var power := s.power * mult
	match s.kind:
		"damage":
			if s.hits_all:
				var total := 0
				for i in _living():
					var d := _foe_damage(i, power)
					total += d
					_hit_enemy(i, d, s.effect)
				await _say("%s uses %s! It hits every enemy for %d damage in total." % [who, s.display_name, total])
			else:
				var dmg := _foe_damage(t, power)
				_hit_enemy(t, dmg, s.effect)
				await _say("%s uses %s! %s takes %d damage." % [who, s.display_name, foes[t].label, dmg])
				if s.status != &"" and foes[t].hp > 0:
					await _inflict(t, s)
		"status":
			_play_fx(s.effect, _enemy_center(t))
			await _inflict(t, s, "%s uses %s! " % [who, s.display_name])
		"heal" when s.hits_all:
			var parts: Array[String] = []
			for id in _alive():
				var before := GameState.get_hp(id)
				GameState.set_member_hp(id, before + int(power))
				_play_fx(s.effect, _center_of(id))
				parts.append("%s +%d" % [GameState.member(id).display_name, GameState.get_hp(id) - before])
			_sfx("battle/patch_up")
			_refresh()
			await _say("%s uses %s! The party recovers HP (%s)." % [who, s.display_name, ", ".join(PackedStringArray(parts))])
		"heal":
			var target := _most_hurt()
			var before := GameState.get_hp(target)
			GameState.set_member_hp(target, before + int(power))
			_play_fx(s.effect, _center_of(target))
			_refresh()
			await _say("%s uses %s! %s recovers %d HP." % [who, s.display_name, GameState.member(target).display_name, GameState.get_hp(target) - before])
		"shield":
			shield_up = true
			_play_fx(s.effect, _center_of(actor))
			await _say("%s raises his Tin Shield to protect Demari!" % who)
		"buff":
			for id in _alive():
				_play_fx(s.effect, _center_of(id))
			if s.status == &"def_up":
				guard_turns = s.turns
				_sfx("battle/def_buff")
				_refresh()
				await _say("%s gives a Royal Salute! The party's Defense rises." % who)
			else:
				buff_turns = s.turns
				_sfx("battle/march_order")
				_refresh()
				await _say("%s calls a March Order! The party's Attack rises." % who)
		"charge":
			charging = true
			charge_target = t
			_play_fx(&"sp_windup", _center_of(actor))
			await _say("%s starts winding his key..." % who)


func _inflict(t: int, s: SkillData, lead := "") -> void:
	var f: Dictionary = foes[t]
	if s.status == &"sleep" and BOSS_MUSIC.has(f.data.id):
		await _say("%s%s won't fall asleep!" % [lead, f.label])
		return
	f.status[s.status] = s.turns
	_sfx("battle/" + STATUS_SFX[s.status])
	_refresh()
	var text: String = {&"poison": "%s is poisoned!", &"sleep": "%s falls asleep!", &"def_down": "%s's Defense drops!"}[s.status]
	await _say(lead + text % f.label)


func _foe_status_turn(i: int) -> bool:
	var f: Dictionary = foes[i]
	if f.status.has(&"sleep"):
		f.status[&"sleep"] -= 1
		if f.status[&"sleep"] <= 0:
			f.status.erase(&"sleep")
			_refresh()
			await _say("%s wakes up!" % f.label)
		else:
			await _say("%s is fast asleep." % f.label)
			return false
	return true


func _foe_status_end(i: int) -> void:
	var f: Dictionary = foes[i]
	if f.hp > 0 and f.status.has(&"poison"):
		var dmg := maxi(2, int(f.data.max_hp / 10.0))
		f.hp = maxi(f.hp - dmg, 0)
		_flash(f.sprite)
		_sfx("battle/poison")
		_refresh()
		await _say("%s takes %d poison damage." % [f.label, dmg])
		if f.hp <= 0:
			var t := create_tween()
			t.tween_property(f.sprite, "modulate:a", 0.0, 0.6)
			f.name.modulate = Color(0.5, 0.5, 0.5)
	for k: StringName in [&"poison", &"def_down"]:
		if f.status.has(k):
			f.status[k] -= 1
			if f.status[k] <= 0:
				f.status.erase(k)
	_refresh()


func _phoenix_check() -> void:
	if _feather_used or not GameState.has_key_item(&"phoenix_feather"):
		return
	for id in GameState.party:
		if GameState.get_hp(id) <= 0:
			_feather_used = true
			GameState.set_member_hp(id, GameState.member(id).max_hp / 2)
			_play_fx(&"sp_magic_burst_green", _center_of(id))
			_refresh()
			await _say("The Phoenix Feather glows! %s is back on their feet!" % GameState.member(id).display_name)
			return


func _unleash_charge() -> void:
	charging = false
	var s: SkillData = null
	for k in GameState.SKILLS:
		if k.kind == "charge":
			s = k
	var t := charge_target if foes[charge_target].hp > 0 else _living()[0]
	await _step(&"casimir")
	actor = &"casimir"
	var dmg := _foe_damage(t, s.power)
	_hit_enemy(t, dmg, s.effect)
	await _say("Casimir unleashes the Wind-Up Charge! %s takes %d damage." % [foes[t].label, dmg])


func _most_hurt() -> StringName:
	var best: StringName = actor
	var best_ratio := 2.0
	for id in _alive():
		var r := float(GameState.get_hp(id)) / GameState.member(id).max_hp
		if r < best_ratio:
			best_ratio = r
			best = id
	return best


func _try_run() -> void:
	if _rng.randf() < RUN_CHANCE:
		await _say("%s got away safely!" % GameState.member(actor).display_name)
		GameState.unlock(&"battle")
		SceneManager.return_from_battle()
	else:
		await _say("Couldn't get away!")
		_end_action()


func _enemy_turn() -> void:
	state = State.ENEMY_TURN
	actor = &""
	_foe_turn = -1
	_refresh()
	for i in _living():
		if _alive().is_empty():
			break
		_foe_turn = i
		_sync_turns()
		if await _foe_status_turn(i):
			await _foe_attacks(i)
		await _phoenix_check()
		await _foe_status_end(i)
	if _alive().is_empty():
		_defeat()
		return
	if buff_turns > 0:
		buff_turns -= 1
	if guard_turns > 0:
		guard_turns -= 1
	_refresh()
	_begin_round()


func _foe_attacks(i: int) -> void:
	var f: Dictionary = foes[i]
	var rage: Dictionary = BOSS_RAGE.get(f.data.id, {})
	if not rage.is_empty() and not f.raging and f.hp * 2 <= f.data.max_hp:
		await _enrage(i, rage)
	if f.raging:
		f.rage_turns += 1
		if f.rage_turns % 2 == 1:
			await _special(i, rage)
			return
	var targets := _alive()
	var target: StringName = targets[_rng.randi_range(0, targets.size() - 1)]
	var blocked := false
	if target == &"demari" and shield_up and GameState.get_hp(&"casimir") > 0:
		target = &"casimir"
		shield_up = false
		blocked = true
	_enemy_anim(i, &"cast")
	var dmg := _hit_member(i, target, &"na_rock" if f.data.id == &"zephyrion" else &"na_claw")
	var tname := GameState.member(target).display_name
	if blocked:
		await _say("Casimir blocks the hit for Demari! He takes %d damage." % dmg)
	else:
		await _say("%s attacks! %s takes %d damage." % [f.label, tname, dmg])
	if GameState.get_hp(target) <= 0:
		await _say("%s is knocked out!" % tname)


func _foe_attack_power(i: int) -> int:
	var f: Dictionary = foes[i]
	return int(f.data.attack * RAGE_ATTACK) if f.raging else f.data.attack


func _hit_member(i: int, target: StringName, fx: StringName) -> int:
	var dmg := _damage(_foe_attack_power(i), GameState.member(target).defense)
	if guarding.get(target, false):
		dmg = maxi(1, int(dmg / 2.0))
	if guard_turns > 0:
		dmg = maxi(1, int(dmg * DEF_UP))
	if GameState.has_key_item(&"star_medal"):
		dmg = maxi(1, int(dmg * 0.85))
	GameState.set_member_hp(target, GameState.get_hp(target) - dmg)
	_play_fx(fx, _center_of(target))
	_flash(_sprites[target])
	_refresh()
	return dmg


func _enrage(i: int, rage: Dictionary) -> void:
	var f: Dictionary = foes[i]
	f.raging = true
	if f.sprite.sprite_frames.has_animation(&"hover"):
		f.rest = &"hover"
	_enemy_anim(i, &"rage")
	_shake()
	_message.text = "%s is enraged! Its Attack rises!" % f.label
	await _rage_banner(rage)
	for q: Array in rage.quips:
		if q[0] in _alive():
			await _say("%s: %s" % [GameState.member(q[0]).display_name, q[1]], QUIP_TIME)


func _rage_banner(rage: Dictionary) -> void:
	var banner := RichTextLabel.new()
	banner.bbcode_enabled = true
	banner.fit_content = true
	banner.scroll_active = false
	banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	banner.size = Vector2(size.x, 0)
	banner.position = Vector2(0, size.y * 0.3)
	var font_path := BOSS_FONTS % rage.font
	if ResourceLoader.exists(font_path):
		banner.add_theme_font_override("normal_font", load(font_path))
	banner.add_theme_font_size_override("normal_font_size", 32)
	banner.add_theme_color_override("default_color", rage.color)
	banner.add_theme_color_override("font_outline_color", Color.BLACK)
	banner.add_theme_constant_override("outline_size", 8)
	banner.text = "[center][shake rate=25.0 level=12]%s[/shake][/center]" % rage.line
	add_child(banner)
	await get_tree().create_timer(QUIP_TIME * 1.5).timeout
	var t := create_tween()
	t.tween_property(banner, "modulate:a", 0.0, 0.3)
	await t.finished
	banner.queue_free()


func _special(i: int, rage: Dictionary) -> void:
	var f: Dictionary = foes[i]
	_enemy_anim(i, &"smash")
	_shake()
	var hit: Array[StringName] = []
	var parts: Array[String] = []
	if rage.both:
		for id in _alive():
			hit.append(id)
			parts.append("%s takes %d" % [GameState.member(id).display_name, _hit_member(i, id, &"na_claw")])
		await _say("%s uses %s! %s damage." % [f.label, rage.special, ", ".join(PackedStringArray(parts))])
	else:
		var targets := _alive()
		var target: StringName = targets[_rng.randi_range(0, targets.size() - 1)]
		hit.append(target)
		var total := _hit_member(i, target, &"na_claw")
		if GameState.get_hp(target) > 0:
			total += _hit_member(i, target, &"na_claw")
		await _say("%s uses %s! It bites %s twice for %d damage." % [f.label, rage.special, GameState.member(target).display_name, total])
	for id in hit:
		if GameState.get_hp(id) <= 0:
			await _say("%s is knocked out!" % GameState.member(id).display_name)


func _shake() -> void:
	var t := create_tween()
	for k in 8:
		t.tween_property(self, "position", Vector2(randf_range(-5, 5), randf_range(-4, 4)), 0.04)
	t.tween_property(self, "position", Vector2.ZERO, 0.04)


func _damage(attack: int, defense: int) -> int:
	return maxi(1, attack - int(defense / 2.0) + _rng.randi_range(-1, 1))


func _victory() -> void:
	state = State.VICTORY
	actor = &""
	for id in GameState.party:
		if GameState.get_hp(id) <= 0:
			GameState.set_member_hp(id, 1)
	var total := 0
	var coins := 0
	_pages.clear()
	for f in foes:
		total += f.data.exp_reward
		coins += f.data.buttons_reward
		GameState.mark_defeated(GameState.pending_battle.get("encounter_id", ""), f.data.id)
		var drop: StringName = GameState.BOSS_DROPS.get(f.data.id, &"")
		if drop != &"" and GameState.give_key_item(drop):
			var info: Array = GameState.KEY_ITEMS[drop]
			_pages.append(["Key item!", "You got the %s!\n%s" % [info[0], info[1]]])
	GameState.add_buttons(coins)
	var up := GameState.add_exp(total)
	if not up.is_empty():
		_pages.append(["Level up!", _level_up_text(up)])
	_refresh()
	var who: String = "%s was defeated." % foes[0].label if foes.size() == 1 else "All enemies were defeated."
	_sfx("ui/buttons_coin")
	_show_result("Victory!", "%s\nThe party gained %d EXP and %d Buttons." % [who, total, coins], ["Continue"])


func _level_up_text(up: Dictionary) -> String:
	var lines: Array[String] = ["The party reached level %d!" % up.to]
	for id: StringName in up.gains:
		var g: Array = up.gains[id]
		lines.append("%s  HP+%d MP+%d ATK+%d DEF+%d SPD+%d" % [GameState.member(id).display_name, g[0], g[1], g[2], g[3], g[4]])
	if not up.skills.is_empty():
		lines.append("New skills learned: %s" % ", ".join(PackedStringArray(up.skills.map(func(s: SkillData) -> String: return s.display_name))))
	return "\n".join(PackedStringArray(lines))


func _defeat() -> void:
	state = State.DEFEAT
	actor = &""
	_show_result("Defeat...", "The party has fallen.", ["Retry battle", "Return to village"])


func _show_result(title: String, text: String, choices: Array[String]) -> void:
	_skill_panel.hide()
	_set_commands([0, 1, 2, 3, 4])
	_disarm_commands()
	_result_title.text = title
	_result_text.text = text
	_result_choices.set_choices(choices)
	_result.show()
	_result_choices.focus_first()


func _on_result_choice(index: int) -> void:
	if state == State.VICTORY and not _pages.is_empty():
		var page: Array = _pages.pop_front()
		if page[0] == "Level up!":
			_sfx("battle/level_up")
			_result.custom_minimum_size.x = 470
		_show_result(page[0], page[1], ["Continue"])
		return
	GameState.unlock(&"battle")
	if state == State.VICTORY:
		SceneManager.return_from_battle()
	elif index == 0:
		SceneManager.retry_battle()
	else:
		GameState.restore_party()
		SceneManager.change_to(SceneManager.VILLAGE_SCENE, "FromField")


func _say(text: String, time := STEP_TIME) -> void:
	_message.text = text
	await get_tree().create_timer(time).timeout


func _step(id: StringName) -> void:
	var spr: AnimatedSprite2D = _sprites[id]
	var axis := "position:y" if _front else "position:x"
	var start: float = spr.position.y if _front else spr.position.x
	spr.play(&"Walking_Up" if _front else &"Walking_Right")
	var t := create_tween()
	t.tween_property(spr, axis, start + (-STEP_FORWARD if _front else STEP_FORWARD), 0.15)
	t.tween_property(spr, axis, start, 0.15)
	await t.finished
	spr.stop()
	spr.frame = 0


func _center_of(id: StringName) -> Vector2:
	var spr: AnimatedSprite2D = _sprites[id]
	var h := spr.sprite_frames.get_frame_texture(spr.animation, 0).get_height() * spr.scale.y
	return spr.position + Vector2(0, -h * 0.45)


func _enemy_center(i: int) -> Vector2:
	var spr: AnimatedSprite2D = foes[i].sprite
	var tex := spr.sprite_frames.get_frame_texture(spr.animation, spr.frame)
	return spr.position + Vector2(0, -tex.get_height() * spr.scale.y * 0.5)


func _play_fx(id: StringName, at: Vector2) -> void:
	var path := FX_PATH % id
	if id == &"" or not ResourceLoader.exists(path):
		return
	var sf: SpriteFrames = load(path)
	var fx := AnimatedSprite2D.new()
	fx.sprite_frames = sf
	fx.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var tex := sf.get_frame_texture(&"default", 0)
	var k := FX_SIZE / maxf(tex.get_width(), tex.get_height())
	fx.scale = Vector2(k, k)
	fx.position = at
	%Stage.add_child(fx)
	fx.animation_finished.connect(fx.queue_free)
	fx.play(&"default")


func _flash(node: CanvasItem) -> void:
	var t := create_tween()
	t.tween_property(node, "self_modulate", Color(1, 0.4, 0.4), 0.08)
	t.tween_property(node, "self_modulate", Color.WHITE, 0.15)

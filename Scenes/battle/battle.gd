extends Control

enum State { BATTLE_START, PLAYER_TURN, ACTION_RESOLUTION, ENEMY_TURN, VICTORY, DEFEAT }
enum Command { ATTACK, SKILLS, ITEMS, DEFEND, RUN }

const COMMANDS: Array[String] = ["Attack", "Skills", "Items", "Defend", "Run"]
const STEP_TIME := 0.9
const FALLBACK_ENEMY: EnemyData = preload("res://data/enemies/slime.tres")
const PALETTE: Shader = preload("res://resources/shaders/palette_shift.gdshader")
const FX_PATH := "res://assets/effects/battle/%s.tres"
const BACKDROP_PATH := "res://assets/backgrounds/battle_%s.png"
const RUN_CHANCE := 0.7
const ENEMY_MAX := Vector2(220, 150)
const FX_SIZE := 72.0
const STEP_FORWARD := 28.0

@onready var _backdrop: TextureRect = %Backdrop
@onready var _enemy_sprite: AnimatedSprite2D = %Enemy
@onready var _enemy_name: Label = %EnemyName
@onready var _enemy_hp: StatBar = %EnemyHP
@onready var _party_rows: VBoxContainer = %PartyRows
@onready var _commands: ChoiceList = %Commands
@onready var _message: Label = %Message
@onready var _result: PanelContainer = %ResultWindow
@onready var _result_title: Label = %ResultTitle
@onready var _result_text: Label = %ResultText
@onready var _result_choices: ChoiceList = %ResultChoices

var state: State = State.BATTLE_START
var enemy: EnemyData
var enemy_hp: int = 0
var actor: StringName = &""
var shield_up: bool = false
var buff_turns: int = 0
var charging: bool = false
var guarding: Dictionary = {}
var _order: Array[StringName] = []
var _index: int = 0
var _menu: String = "main"
var _menu_skills: Array[SkillData] = []
var _sprites: Dictionary = {}
var _rows: Dictionary = {}
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	GameState.lock(&"battle")
	enemy = GameState.pending_battle.get("enemy", FALLBACK_ENEMY)
	enemy_hp = enemy.max_hp
	_result.hide()
	_commands.chosen.connect(_on_command)
	_result_choices.chosen.connect(_on_result_choice)
	_sprites = {&"demari": %Demari, &"casimir": %Casimir}
	_setup_view()
	_refresh()
	_start()


func _setup_view() -> void:
	var bd := BACKDROP_PATH % GameState.pending_battle.get("backdrop", "woods")
	if ResourceLoader.exists(bd):
		_backdrop.texture = load(bd)
	_enemy_name.text = enemy.display_name
	for id: StringName in _sprites:
		_sprites[id].visible = id in GameState.party
	for id in GameState.party:
		_rows[id] = _make_row(id)
	_setup_enemy_sprite()


func _make_row(id: StringName) -> Dictionary:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	var name_label := Label.new()
	name_label.text = GameState.member(id).display_name
	name_label.theme_type_variation = &"NameLabel"
	name_label.custom_minimum_size.x = 64
	row.add_child(name_label)
	var hp_bar := StatBar.new()
	hp_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(hp_bar)
	var mp_bar := StatBar.new()
	mp_bar.label_text = "MP"
	mp_bar.bar_variation = &"MPBar"
	mp_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(mp_bar)
	_party_rows.add_child(row)
	return {"name": name_label, "hp": hp_bar, "mp": mp_bar}


func _setup_enemy_sprite() -> void:
	var sf := enemy.frames
	if sf == null:
		sf = SpriteFrames.new()
		sf.add_animation(&"idle")
		if enemy.sprite_sheet:
			var at := AtlasTexture.new()
			at.atlas = enemy.sprite_sheet
			at.region = Rect2(Vector2.ZERO, enemy.sprite_sheet.get_size() / Vector2(maxi(enemy.hframes, 1), maxi(enemy.vframes, 1)))
			sf.add_frame(&"idle", at)
			_enemy_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		else:
			sf.add_frame(&"idle", PlaceholderTexture2D.new())
	_enemy_sprite.sprite_frames = sf
	var first := sf.get_frame_texture(&"idle", 0)
	var k := minf(ENEMY_MAX.x / first.get_width(), ENEMY_MAX.y / first.get_height())
	_enemy_sprite.scale = Vector2(k, k)
	if enemy.hue_shift != 0.0 or enemy.saturation != 1.0 or enemy.brightness != 1.0:
		var m := ShaderMaterial.new()
		m.shader = PALETTE
		m.set_shader_parameter("hue_shift", enemy.hue_shift)
		m.set_shader_parameter("saturation", enemy.saturation)
		m.set_shader_parameter("brightness", enemy.brightness)
		_enemy_sprite.material = m
	_enemy_sprite.frame_changed.connect(_align_enemy)
	_enemy_sprite.animation_finished.connect(func() -> void: if enemy_hp > 0: _enemy_sprite.play(&"idle"))
	_enemy_sprite.play(&"idle")
	_align_enemy()


func _align_enemy() -> void:
	var tex := _enemy_sprite.sprite_frames.get_frame_texture(_enemy_sprite.animation, _enemy_sprite.frame)
	if tex:
		_enemy_sprite.offset = Vector2(0, -tex.get_height() / 2.0)


func _enemy_anim(anim: StringName) -> void:
	if _enemy_sprite.sprite_frames.has_animation(anim):
		_enemy_sprite.play(anim)


func _refresh() -> void:
	_enemy_hp.set_values(enemy_hp, enemy.max_hp)
	for id: StringName in _rows:
		var m := GameState.member(id)
		_rows[id].hp.set_values(GameState.get_hp(id), m.max_hp)
		_rows[id].mp.set_values(GameState.get_mp(id), m.max_mp)
		_rows[id].name.modulate = Color(1, 0.9, 0.4) if id == actor and state == State.PLAYER_TURN else Color.WHITE
		var spr: AnimatedSprite2D = _sprites[id]
		spr.modulate = Color(0.45, 0.45, 0.45) if GameState.get_hp(id) <= 0 else Color.WHITE


func _alive() -> Array[StringName]:
	var out: Array[StringName] = []
	for id in GameState.party:
		if GameState.get_hp(id) > 0:
			out.append(id)
	return out


func _start() -> void:
	_commands.set_choices(COMMANDS, [0, 1, 2, 3, 4])
	_commands.disarm()
	await _say("A wild %s appears!" % enemy.display_name)
	if enemy.speed > GameState.HERO.speed:
		await _enemy_turn()
	else:
		_begin_round()


func _begin_round() -> void:
	if state == State.VICTORY or state == State.DEFEAT:
		return
	_order = _alive()
	_index = 0
	_next_actor()


func _next_actor() -> void:
	if state == State.VICTORY or state == State.DEFEAT:
		return
	if enemy_hp <= 0:
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
	var disabled: Array[int] = [Command.ITEMS]
	if GameState.skills_for(actor).is_empty():
		disabled.append(Command.SKILLS)
	if actor != &"demari" or not enemy.can_run:
		disabled.append(Command.RUN)
	_message.text = "What will %s do?" % GameState.member(actor).display_name
	_commands.set_choices(COMMANDS, disabled)
	_commands.focus_first()
	_refresh()


func _show_skill_menu() -> void:
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
	_commands.set_choices(names, disabled)
	_commands.focus_first()


func _on_command(index: int) -> void:
	if state != State.PLAYER_TURN:
		return
	if _menu == "skills":
		if index >= _menu_skills.size():
			_show_main_menu()
			return
		state = State.ACTION_RESOLUTION
		await _use_skill(_menu_skills[index])
		_end_action()
		return
	match index:
		Command.ATTACK:
			state = State.ACTION_RESOLUTION
			await _attack()
			_end_action()
		Command.SKILLS:
			_show_skill_menu()
		Command.DEFEND:
			state = State.ACTION_RESOLUTION
			guarding[actor] = true
			await _say("%s is defending." % GameState.member(actor).display_name)
			_end_action()
		Command.RUN:
			state = State.ACTION_RESOLUTION
			await _try_run()


func _end_action() -> void:
	_refresh()
	if state == State.VICTORY or state == State.DEFEAT:
		return
	_index += 1
	_next_actor()


func _attack_power(id: StringName) -> int:
	var a := GameState.member(id).attack
	return int(a * 1.5) if buff_turns > 0 else a


func _hit_enemy(dmg: int, fx: StringName) -> void:
	enemy_hp = maxi(enemy_hp - dmg, 0)
	_play_fx(fx, _enemy_center())
	_enemy_anim(&"damage")
	_flash(_enemy_sprite)
	_refresh()
	if enemy_hp <= 0:
		var t := create_tween()
		t.tween_property(_enemy_sprite, "modulate:a", 0.0, 0.6)


func _attack() -> void:
	await _step(actor)
	var dmg := _damage(_attack_power(actor), enemy.defense)
	_hit_enemy(dmg, &"na_cut")
	await _say("%s attacks! %s takes %d damage." % [GameState.member(actor).display_name, enemy.display_name, dmg])


func _use_skill(s: SkillData) -> void:
	var who := GameState.member(actor).display_name
	GameState.set_member_mp(actor, GameState.get_mp(actor) - s.mp_cost)
	_refresh()
	await _step(actor)
	match s.kind:
		"damage":
			var dmg := _damage(int(_attack_power(actor) * s.power), enemy.defense)
			_hit_enemy(dmg, s.effect)
			await _say("%s uses %s! %s takes %d damage." % [who, s.display_name, enemy.display_name, dmg])
		"heal":
			var target := _most_hurt()
			var before := GameState.get_hp(target)
			GameState.set_member_hp(target, before + int(s.power))
			_play_fx(s.effect, _center_of(target))
			_refresh()
			await _say("%s uses %s! %s recovers %d HP." % [who, s.display_name, GameState.member(target).display_name, GameState.get_hp(target) - before])
		"shield":
			shield_up = true
			_play_fx(s.effect, _center_of(actor))
			await _say("%s raises his Tin Shield to protect Demari!" % who)
		"buff":
			buff_turns = s.turns
			for id in _alive():
				_play_fx(s.effect, _center_of(id))
			await _say("%s calls a March Order! The party's Attack rises." % who)
		"charge":
			charging = true
			_play_fx(&"sp_windup", _center_of(actor))
			await _say("%s starts winding his key..." % who)


func _unleash_charge() -> void:
	charging = false
	var s: SkillData = null
	for k in GameState.SKILLS:
		if k.kind == "charge":
			s = k
	await _step(&"casimir")
	var dmg := _damage(int(_attack_power(&"casimir") * s.power), enemy.defense)
	_hit_enemy(dmg, s.effect)
	await _say("Casimir unleashes the Wind-Up Charge! %s takes %d damage." % [enemy.display_name, dmg])


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
	_refresh()
	var targets := _alive()
	if targets.is_empty():
		_defeat()
		return
	var target: StringName = targets[_rng.randi_range(0, targets.size() - 1)]
	var blocked := false
	if target == &"demari" and shield_up and GameState.get_hp(&"casimir") > 0:
		target = &"casimir"
		shield_up = false
		blocked = true
	_enemy_anim(&"cast")
	var dmg := _damage(enemy.attack, GameState.member(target).defense)
	if guarding.get(target, false):
		dmg = maxi(1, int(dmg / 2.0))
	GameState.set_member_hp(target, GameState.get_hp(target) - dmg)
	_play_fx(&"na_rock" if enemy.id == &"zephyrion" else &"na_claw", _center_of(target))
	_flash(_sprites[target])
	_refresh()
	var tname := GameState.member(target).display_name
	if blocked:
		await _say("Casimir blocks the hit for Demari! He takes %d damage." % dmg)
	else:
		await _say("%s attacks! %s takes %d damage." % [enemy.display_name, tname, dmg])
	if GameState.get_hp(target) <= 0:
		await _say("%s is knocked out!" % tname)
	if _alive().is_empty():
		_defeat()
		return
	if buff_turns > 0:
		buff_turns -= 1
	_begin_round()


func _damage(attack: int, defense: int) -> int:
	return maxi(1, attack - int(defense / 2.0) + _rng.randi_range(-1, 1))


func _victory() -> void:
	state = State.VICTORY
	actor = &""
	for id in GameState.party:
		if GameState.get_hp(id) <= 0:
			GameState.set_member_hp(id, 1)
	GameState.add_exp(enemy.exp_reward)
	GameState.mark_defeated(GameState.pending_battle.get("encounter_id", ""), enemy.id)
	_refresh()
	_show_result("Victory!", "%s was defeated.\nThe party gained %d EXP." % [enemy.display_name, enemy.exp_reward], ["Continue"])


func _defeat() -> void:
	state = State.DEFEAT
	actor = &""
	_show_result("Defeat...", "The party has fallen.", ["Retry battle", "Return to village"])


func _show_result(title: String, text: String, choices: Array[String]) -> void:
	_commands.set_choices(COMMANDS, [0, 1, 2, 3, 4])
	_commands.disarm()
	_result_title.text = title
	_result_text.text = text
	_result_choices.set_choices(choices)
	_result.show()
	_result_choices.focus_first()


func _on_result_choice(index: int) -> void:
	GameState.unlock(&"battle")
	if state == State.VICTORY:
		SceneManager.return_from_battle()
	elif index == 0:
		SceneManager.retry_battle()
	else:
		GameState.restore_party()
		SceneManager.change_to(SceneManager.VILLAGE_SCENE, "FromField")


func _say(text: String) -> void:
	_message.text = text
	await get_tree().create_timer(STEP_TIME).timeout


func _step(id: StringName) -> void:
	var spr: AnimatedSprite2D = _sprites[id]
	var x := spr.position.x
	spr.play(&"Walking_Right")
	var t := create_tween()
	t.tween_property(spr, "position:x", x + STEP_FORWARD, 0.15)
	t.tween_property(spr, "position:x", x, 0.15)
	await t.finished
	spr.stop()
	spr.frame = 0


func _center_of(id: StringName) -> Vector2:
	var spr: AnimatedSprite2D = _sprites[id]
	var h := spr.sprite_frames.get_frame_texture(spr.animation, 0).get_height() * spr.scale.y
	return spr.position + Vector2(0, -h * 0.45)


func _enemy_center() -> Vector2:
	var tex := _enemy_sprite.sprite_frames.get_frame_texture(_enemy_sprite.animation, _enemy_sprite.frame)
	return _enemy_sprite.position + Vector2(0, -tex.get_height() * _enemy_sprite.scale.y * 0.5)


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

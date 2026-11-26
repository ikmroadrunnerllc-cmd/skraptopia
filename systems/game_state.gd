extends Node

signal stats_changed
signal enemy_defeated(enemy_id: StringName)

const HERO: CharacterData = preload("res://data/characters/hero.tres")
const CASIMIR: CharacterData = preload("res://data/characters/casimir.tres")
const ASMARA: CharacterData = preload("res://data/characters/asmara.tres")
const SETTINGS_PATH := "user://settings.cfg"
const SKILLS: Array[SkillData] = [
	preload("res://data/skills/scribble_strike.tres"),
	preload("res://data/skills/patch_up.tres"),
	preload("res://data/skills/eraser_blast.tres"),
	preload("res://data/skills/tin_shield.tres"),
	preload("res://data/skills/march_order.tres"),
	preload("res://data/skills/wind_up_charge.tres"),
	preload("res://data/skills/ink_splash.tres"),
	preload("res://data/skills/lullaby_doodle.tres"),
	preload("res://data/skills/group_patch.tres"),
	preload("res://data/skills/dent_strike.tres"),
	preload("res://data/skills/cannon_volley.tres"),
	preload("res://data/skills/royal_salute.tres"),
	preload("res://data/skills/royal_mend.tres"),
	preload("res://data/skills/spark_wand.tres"),
	preload("res://data/skills/crown_light.tres"),
]
const EXP_TABLE: Array[int] = [0, 0, 20, 50, 100, 170, 260, 380, 530, 720, 950]
const MAX_LEVEL := 10
const ITEMS: Array[ItemData] = [
	preload("res://data/items/glue_stick.tres"),
	preload("res://data/items/juice_box.tres"),
	preload("res://data/items/bandage_tape.tres"),
]
const KEY_ITEMS := {
	&"steel_fang": ["Steel Fang", "The party deals 15% more damage.", "res://assets/ui/kyrise/necklace_03e.png"],
	&"phoenix_feather": ["Phoenix Feather", "Once per battle, revives the first knocked-out ally at half HP.", "res://assets/items/ninja_adventure/Resource/feather.png"],
	&"star_medal": ["Star Medal", "The party takes 15% less damage.", "res://assets/ui/kyrise/necklace_02d.png"],
}
const BOSS_DROPS := {&"iron_jaws": &"steel_fang", &"kilnoxx": &"phoenix_feather", &"captain_crackjack": &"star_medal"}
const STATS: Array[String] = ["max_hp", "max_mp", "attack", "defense", "speed"]
const GROWTH: Array[String] = ["hp_growth", "mp_growth", "attack_growth", "defense_growth", "speed_growth"]

var party: Array[StringName] = [&"demari", &"casimir", &"asmara"]
var hp: int = HERO.max_hp
var mp: int = HERO.max_mp
var casimir_hp: int = CASIMIR.max_hp
var casimir_mp: int = CASIMIR.max_mp
var asmara_hp: int = ASMARA.max_hp
var asmara_mp: int = ASMARA.max_mp
var exp: int = 0
var level: int = HERO.level
var defeated_encounters: Dictionary = {}
var pending_battle: Dictionary = {}
var _locks: Dictionary = {}
var boss_music_lyrics: bool = false
var buttons: int = 0
var inventory: Dictionary = {}
var key_items: Array[StringName] = []
var flags: Dictionary = {}
var _base: Dictionary = {}


func _ready() -> void:
	for m: CharacterData in [HERO, CASIMIR, ASMARA]:
		_base[m.id] = STATS.map(func(s: String) -> int: return m.get(s))
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) == OK:
		boss_music_lyrics = cfg.get_value("audio", "boss_music_lyrics", false)


func set_boss_music_lyrics(on: bool) -> void:
	boss_music_lyrics = on
	var cfg := ConfigFile.new()
	cfg.load(SETTINGS_PATH)
	cfg.set_value("audio", "boss_music_lyrics", on)
	cfg.save(SETTINGS_PATH)


func lock(reason: StringName) -> void:
	_locks[reason] = true


func unlock(reason: StringName) -> void:
	_locks.erase(reason)


func is_locked() -> bool:
	return not _locks.is_empty()


func set_hp(value: int) -> void:
	hp = clampi(value, 0, member(&"demari").max_hp)
	stats_changed.emit()


func member(id: StringName) -> CharacterData:
	match id:
		&"casimir":
			return CASIMIR
		&"asmara":
			return ASMARA
	return HERO


func get_hp(id: StringName) -> int:
	match id:
		&"casimir":
			return casimir_hp
		&"asmara":
			return asmara_hp
	return hp


func get_mp(id: StringName) -> int:
	match id:
		&"casimir":
			return casimir_mp
		&"asmara":
			return asmara_mp
	return mp


func set_member_hp(id: StringName, value: int) -> void:
	var v := clampi(value, 0, member(id).max_hp)
	match id:
		&"casimir":
			casimir_hp = v
		&"asmara":
			asmara_hp = v
		_:
			hp = v
	stats_changed.emit()


func set_member_mp(id: StringName, value: int) -> void:
	var v := clampi(value, 0, member(id).max_mp)
	match id:
		&"casimir":
			casimir_mp = v
		&"asmara":
			asmara_mp = v
		_:
			mp = v
	stats_changed.emit()


func skills_for(id: StringName) -> Array[SkillData]:
	var out: Array[SkillData] = []
	for s in SKILLS:
		if s.user == id and s.unlock_level <= level:
			out.append(s)
	return out


func new_game() -> void:
	party = [&"demari"]
	flags.clear()
	defeated_encounters.clear()
	pending_battle = {}
	inventory.clear()
	key_items.clear()
	buttons = 0
	exp = 0
	set_level(1)
	restore_party()
	set_member_hp(&"casimir", CASIMIR.max_hp)
	set_member_mp(&"casimir", CASIMIR.max_mp)
	set_member_hp(&"asmara", ASMARA.max_hp)
	set_member_mp(&"asmara", ASMARA.max_mp)


func set_flag(id: StringName) -> void:
	flags[id] = true


func has_flag(id: StringName) -> bool:
	return flags.has(id)


func join_party(id: StringName) -> void:
	if id not in party:
		party.append(id)
		set_member_hp(id, member(id).max_hp)
		set_member_mp(id, member(id).max_mp)


func restore_party() -> void:
	for id in party:
		set_member_hp(id, member(id).max_hp)
		set_member_mp(id, member(id).max_mp)


func add_exp(amount: int) -> Dictionary:
	exp += maxi(amount, 0)
	var from := level
	var to := level
	while to < MAX_LEVEL and exp >= EXP_TABLE[to + 1]:
		to += 1
	if to == from:
		stats_changed.emit()
		return {}
	var before := {}
	for id in party:
		before[id] = STATS.map(func(s: String) -> int: return member(id).get(s))
	set_level(to)
	var gains := {}
	for id in party:
		var m := member(id)
		gains[id] = []
		for k in STATS.size():
			gains[id].append(m.get(STATS[k]) - before[id][k])
		set_member_hp(id, get_hp(id) + gains[id][0])
		set_member_mp(id, get_mp(id) + gains[id][1])
	var learned: Array[SkillData] = []
	for s in SKILLS:
		if s.unlock_level > from and s.unlock_level <= to:
			learned.append(s)
	return {"from": from, "to": to, "gains": gains, "skills": learned}


func exp_to_next() -> int:
	return 0 if level >= MAX_LEVEL else EXP_TABLE[level + 1] - exp


func set_level(value: int) -> void:
	level = clampi(value, 1, MAX_LEVEL)
	refresh_stats()


func refresh_stats() -> void:
	for m: CharacterData in [HERO, CASIMIR, ASMARA]:
		for k in STATS.size():
			m.set(STATS[k], _base[m.id][k] + m.get(GROWTH[k]) * (level - 1))
	for id: StringName in [&"demari", &"casimir", &"asmara"]:
		set_member_hp(id, get_hp(id))
		set_member_mp(id, get_mp(id))


func add_buttons(amount: int) -> void:
	buttons = maxi(buttons + amount, 0)
	stats_changed.emit()


func add_item(id: StringName, count := 1) -> void:
	inventory[id] = inventory.get(id, 0) + count
	if inventory[id] <= 0:
		inventory.erase(id)
	stats_changed.emit()


func item(id: StringName) -> ItemData:
	for i in ITEMS:
		if i.id == id:
			return i
	return null


func buy(id: StringName) -> bool:
	var i := item(id)
	if i == null or buttons < i.price:
		return false
	add_buttons(-i.price)
	add_item(id)
	return true


func use_item(id: StringName, target: StringName) -> String:
	var i := item(id)
	if i == null or inventory.get(id, 0) <= 0:
		return ""
	var m := member(target)
	var hp0 := get_hp(target)
	var mp0 := get_mp(target)
	if i.full_heal:
		set_member_hp(target, m.max_hp)
	set_member_hp(target, get_hp(target) + i.heal_hp)
	set_member_mp(target, get_mp(target) + i.heal_mp)
	add_item(id, -1)
	var parts: Array[String] = []
	if get_hp(target) > hp0:
		parts.append("%d HP" % (get_hp(target) - hp0))
	if get_mp(target) > mp0:
		parts.append("%d MP" % (get_mp(target) - mp0))
	if parts.is_empty():
		return "%s uses the %s. Nothing happens." % [m.display_name, i.display_name]
	return "%s uses the %s and recovers %s." % [m.display_name, i.display_name, " and ".join(PackedStringArray(parts))]


func has_key_item(id: StringName) -> bool:
	return id in key_items


func give_key_item(id: StringName) -> bool:
	if id in key_items:
		return false
	key_items.append(id)
	stats_changed.emit()
	return true


func mark_defeated(encounter_id: String, enemy_id: StringName) -> void:
	if encounter_id != "":
		defeated_encounters[encounter_id] = Time.get_ticks_msec()
	enemy_defeated.emit(enemy_id)


func is_defeated(encounter_id: String) -> bool:
	return defeated_encounters.has(encounter_id)


func seconds_since_defeat(encounter_id: String) -> float:
	return (Time.get_ticks_msec() - int(defeated_encounters.get(encounter_id, 0))) / 1000.0


func forget_defeat(encounter_id: String) -> void:
	defeated_encounters.erase(encounter_id)

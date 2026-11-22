extends Node

signal stats_changed
signal enemy_defeated(enemy_id: StringName)

const HERO: CharacterData = preload("res://data/characters/hero.tres")
const CASIMIR: CharacterData = preload("res://data/characters/casimir.tres")
const SETTINGS_PATH := "user://settings.cfg"
const SKILLS: Array[SkillData] = [
	preload("res://data/skills/scribble_strike.tres"),
	preload("res://data/skills/patch_up.tres"),
	preload("res://data/skills/eraser_blast.tres"),
	preload("res://data/skills/tin_shield.tres"),
	preload("res://data/skills/march_order.tres"),
	preload("res://data/skills/wind_up_charge.tres"),
]

var party: Array[StringName] = [&"demari", &"casimir"]
var hp: int = HERO.max_hp
var mp: int = HERO.max_mp
var casimir_hp: int = CASIMIR.max_hp
var casimir_mp: int = CASIMIR.max_mp
var exp: int = 0
var level: int = HERO.level
var defeated_encounters: Dictionary = {}
var pending_battle: Dictionary = {}
var _locks: Dictionary = {}
var boss_music_lyrics: bool = false


func _ready() -> void:
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
	hp = clampi(value, 0, HERO.max_hp)
	stats_changed.emit()


func member(id: StringName) -> CharacterData:
	return CASIMIR if id == &"casimir" else HERO


func get_hp(id: StringName) -> int:
	return casimir_hp if id == &"casimir" else hp


func get_mp(id: StringName) -> int:
	return casimir_mp if id == &"casimir" else mp


func set_member_hp(id: StringName, value: int) -> void:
	if id == &"casimir":
		casimir_hp = clampi(value, 0, CASIMIR.max_hp)
		stats_changed.emit()
	else:
		set_hp(value)


func set_member_mp(id: StringName, value: int) -> void:
	if id == &"casimir":
		casimir_mp = clampi(value, 0, CASIMIR.max_mp)
	else:
		mp = clampi(value, 0, HERO.max_mp)
	stats_changed.emit()


func skills_for(id: StringName) -> Array[SkillData]:
	var out: Array[SkillData] = []
	for s in SKILLS:
		if s.user == id and s.unlock_level <= level:
			out.append(s)
	return out


func restore_party() -> void:
	for id in party:
		set_member_hp(id, member(id).max_hp)
		set_member_mp(id, member(id).max_mp)


func add_exp(amount: int) -> void:
	exp += maxi(amount, 0)
	stats_changed.emit()


func mark_defeated(encounter_id: String, enemy_id: StringName) -> void:
	if encounter_id != "":
		defeated_encounters[encounter_id] = true
	enemy_defeated.emit(enemy_id)


func is_defeated(encounter_id: String) -> bool:
	return defeated_encounters.has(encounter_id)

extends Node

signal stats_changed
signal enemy_defeated(enemy_id: StringName)

const HERO: CharacterData = preload("res://data/characters/hero.tres")

var hp: int = HERO.max_hp
var mp: int = HERO.max_mp
var exp: int = 0
var level: int = HERO.level
var defeated_encounters: Dictionary = {}
var pending_battle: Dictionary = {}
var _locks: Dictionary = {}


func lock(reason: StringName) -> void:
	_locks[reason] = true


func unlock(reason: StringName) -> void:
	_locks.erase(reason)


func is_locked() -> bool:
	return not _locks.is_empty()


func set_hp(value: int) -> void:
	hp = clampi(value, 0, HERO.max_hp)
	stats_changed.emit()


func add_exp(amount: int) -> void:
	exp += maxi(amount, 0)
	stats_changed.emit()


func mark_defeated(encounter_id: String, enemy_id: StringName) -> void:
	if encounter_id != "":
		defeated_encounters[encounter_id] = true
	enemy_defeated.emit(enemy_id)


func is_defeated(encounter_id: String) -> bool:
	return defeated_encounters.has(encounter_id)

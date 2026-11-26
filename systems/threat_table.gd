class_name ThreatTable
extends RefCounted

const DECAY_PERCENT := 20
const LOW_HP_PERCENT := 25
const TAUNT := 20

var values: Dictionary = {}


func get_threat(id: StringName) -> int:
	return values.get(id, 0)


func add(id: StringName, amount: int) -> void:
	values[id] = maxi(get_threat(id) + amount, 0)


func add_healing(user: StringName, target: StringName, amount: int, target_max_hp: int) -> void:
	var ratio := clampf(float(amount) / maxi(target_max_hp, 1), 0.0, 1.0)
	add(user, int(get_threat(target) * ratio) + int(amount / 2.0))


func add_low_hp(id: StringName, hp: int, max_hp: int) -> void:
	if hp > 0 and hp * 100 <= max_hp * LOW_HP_PERCENT:
		add(id, int((max_hp - hp) / 2.0))


func decay() -> void:
	for id: StringName in values:
		values[id] = int(values[id] * (100 - DECAY_PERCENT) / 100.0)


func top(alive: Array[StringName]) -> StringName:
	var best: StringName = &""
	var best_value := 0
	for id in alive:
		if get_threat(id) > best_value:
			best = id
			best_value = get_threat(id)
	return best


func share(id: StringName, alive: Array[StringName]) -> float:
	var total := 0
	for other in alive:
		total += get_threat(other)
	if total <= 0 or id not in alive:
		return 0.0
	return float(get_threat(id)) / total

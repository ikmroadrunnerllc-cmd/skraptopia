class_name AIRule
extends Resource

enum Pick { THREAT_TARGET, LOWEST_HP, RANDOM, ALL }

@export var move_name: String = ""
@export var power: float = 1.0
@export var priority: int = 1
@export var weight: int = 10
@export var pick: Pick = Pick.THREAT_TARGET
@export var effect: StringName = &"na_claw"
@export var conditions: Array[AICondition] = []


func passes(ctx: Dictionary) -> bool:
	return conditions.all(func(c: AICondition) -> bool: return c.is_met(ctx))


static func choose(rules: Array[AIRule], ctx: Dictionary, rng: RandomNumberGenerator) -> AIRule:
	var passing: Array[AIRule] = rules.filter(func(r: AIRule) -> bool: return r.passes(ctx))
	if passing.is_empty():
		return null
	var top_priority: int = passing.map(func(r: AIRule) -> int: return r.priority).max()
	var candidates: Array[AIRule] = passing.filter(func(r: AIRule) -> bool: return r.priority == top_priority)
	var total := 0
	for r in candidates:
		total += maxi(r.weight, 0)
	if total <= 0:
		return candidates[0]
	var roll := rng.randi_range(1, total)
	for r in candidates:
		roll -= maxi(r.weight, 0)
		if roll <= 0:
			return r
	return candidates[-1]

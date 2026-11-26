class_name AICondition
extends Resource

enum Check { SELF_HP_BELOW, SELF_HP_ABOVE, ANY_MEMBER_HP_BELOW, EVERY_N_TURNS, RANDOM_PERCENT, ALLY_DOWN, PARTY_BUFFED }

@export var check: Check = Check.SELF_HP_BELOW
@export var value: int = 30


func is_met(ctx: Dictionary) -> bool:
	match check:
		Check.SELF_HP_BELOW:
			return ctx.self_hp_percent < value
		Check.SELF_HP_ABOVE:
			return ctx.self_hp_percent > value
		Check.ANY_MEMBER_HP_BELOW:
			return ctx.member_hp_percents.any(func(p: int) -> bool: return p < value)
		Check.EVERY_N_TURNS:
			return value > 0 and (ctx.turns + 1) % value == 0
		Check.RANDOM_PERCENT:
			return ctx.rng.randi_range(1, 100) <= value
		Check.ALLY_DOWN:
			return ctx.ally_down
		Check.PARTY_BUFFED:
			return ctx.party_buffed
	return false

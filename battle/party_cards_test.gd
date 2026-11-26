extends Control
## Stand-alone test for the party / enemy cards. Run this scene (F6).
##  Enter/Space: hit the active party member  ·  Esc: heal them
##  Tab: next party member's turn (gold frame)  ·  Up/Down: move the target (blue frame) between enemies

const PANEL_SCENE := preload("res://battle/battler_panel.tscn")
const ICON := "res://assets/ui/ninja_adventure/Skill Icon/%s.png"

var members: Array[BattlerPanel] = []
var monsters: Array[BattlerPanel] = []
var active := 0
var target := 0


func _ready() -> void:
	var party := [
		{"name": "Demari", "hp": 34, "hpMax": 34, "mp": 12, "mpMax": 12, "ap": 1, "apMax": 3,
			"statuses": [Status("Spell/AttackUpgrade", 1, 3), Status("Spell/OrbPlant", 2, 2)]},
		{"name": "Casimir", "hp": 41, "hpMax": 48, "mp": 0, "mpMax": 8, "ap": 3, "apMax": 3,
			# 7 statuses: the row scrolls; 8 turns shows the gold pip tier.
			"statuses": [Status("Spell/DefenseUpgrade", 1, 8), Status("Spell/AttackUpgrade", 1, 2), Status("Spell/Downgrade", 2, 4),
				Status("Meteo/Moon", 2, 1), Status("Spell/OrbPlant", 2, 3), Status("Spell/BookFire", 3, 0, true), Status("Spell/AttackUpgrade", 1, 13)]},
	]
	var troop := [
		{"name": "Slime A", "hp": 20, "hpMax": 20, "statuses": [Status("Meteo/Moon", 2, 2)]},
		{"name": "Frost Spider", "hp": 9, "hpMax": 30},
		{"name": "Slime B", "hp": 4, "hpMax": 20},
	]
	for i in party.size():
		members.append(Spawn(party[i], true, Vector2(532, 10 + 62 * i)))
	for i in troop.size():
		monsters.append(Spawn(troop[i], false, Vector2(12, 10 + 46 * i)))
	for panel in members + monsters:
		panel.SetBackdrop(true)
	members[active].SetInputActive(true)
	monsters[target].SetSelected(true)


func Spawn(data: Dictionary, member: bool, at: Vector2) -> BattlerPanel:
	var panel: BattlerPanel = PANEL_SCENE.instantiate()
	add_child(panel)
	panel.position = at
	panel.Setup(data, member)
	return panel


func Status(icon: String, category: int, count: int, permanent := false) -> Dictionary:
	return {"icon": load(ICON % icon), "category": category, "count": count, "permanent": permanent}


func _unhandled_input(event: InputEvent) -> void:
	var panel := members[active]
	if event.is_action_pressed("ui_accept"):
		ChangeHp(panel, -7)
	elif event.is_action_pressed("ui_cancel"):
		ChangeHp(panel, 10)
	elif event.is_action_pressed("ui_focus_next"):
		panel.SetInputActive(false)
		active = (active + 1) % members.size()
		members[active].SetInputActive(true)
	elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
		monsters[target].SetSelected(false)
		target = wrapi(target + (1 if event.is_action_pressed("ui_down") else -1), 0, monsters.size())
		monsters[target].SetSelected(true)
	else:
		return
	get_viewport().set_input_as_handled()


func ChangeHp(panel: BattlerPanel, amount: int) -> void:
	var b := panel.battler
	b.hp = clampi(b.hp + amount, 0, b.hpMax)
	panel.hpGauge.AnimateTo(b.hp)
	panel.nameText.color = BattleStyle.HpColor(b.hp, b.hpMax, BattleStyle.COLOR_BASE)

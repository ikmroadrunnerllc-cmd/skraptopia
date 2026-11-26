extends Control
## Stand-alone test for the command menu. Run this scene (F6).
##  Up/Down: move the arrow  ·  Enter/Space: choose (the menu closes and reopens)
##  "Run" is greyed out to show a disabled command (it can't be chosen).

const ICONS := ["sword_01a", "spellbook_01a", "potion_01a", "shield_01a", "boots_01a"]
const NAMES := ["Attack", "Skills", "Items", "Defend", "Run"]

@onready var menu: BattleCommandWindow = $CommandWindow
@onready var message: Label = $Message


func _ready() -> void:
	menu.commandChosen.connect(OnChosen)
	menu.enemyInfoRequested.connect(func() -> void: message.text = "Left: enemy info")
	menu.turnOrderRequested.connect(func() -> void: message.text = "Right: turn order")
	Open()


func Open() -> void:
	var items := []
	for i in NAMES.size():
		items.append({"icon": load("res://assets/ui/kyrise/%s.png" % ICONS[i]), "text": NAMES[i], "enabled": NAMES[i] != "Run"})
	menu.Setup(items)


func OnChosen(index: int) -> void:
	message.text = "Chose: " + NAMES[index]
	menu.Close()
	await get_tree().create_timer(0.6).timeout
	Open()

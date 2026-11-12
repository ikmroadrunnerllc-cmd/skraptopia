extends Control

const ITEMS: Array[String] = ["Status", "Quests", "Resume"]

@onready var _list: ChoiceList = %MenuList
@onready var _info_panel: PanelContainer = %InfoPanel
@onready var _info: Label = %InfoText

var _open: bool = false
var _in_submenu: bool = false


func _ready() -> void:
	hide()
	_list.chosen.connect(_on_chosen)


func is_open() -> bool:
	return _open


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if not _open:
		if event.is_action_pressed("menu") and _can_open():
			get_viewport().set_input_as_handled()
			_open_menu()
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		get_viewport().set_input_as_handled()
		if _in_submenu:
			_back_to_list()
		else:
			_close_menu()


func _can_open() -> bool:
	return not GameState.is_locked() and get_tree().get_first_node_in_group("player") != null


func _open_menu() -> void:
	_open = true
	GameState.lock(&"menu")
	show()
	_back_to_list()


func _back_to_list() -> void:
	_in_submenu = false
	_info_panel.hide()
	_list.set_choices(ITEMS)
	_list.focus_first()


func _close_menu() -> void:
	_open = false
	_list.disarm()
	hide()
	await get_tree().create_timer(0.15).timeout
	if not _open:
		GameState.unlock(&"menu")


func _on_chosen(index: int) -> void:
	match index:
		0:
			_show_info(_status_text())
		1:
			_show_info(_quest_text())
		2:
			_close_menu()


func _show_info(text: String) -> void:
	_in_submenu = true
	_info.text = text
	_info_panel.show()
	_list.set_choices(ITEMS)
	_list.disarm()
	_list.focus_first()


func _status_text() -> String:
	var h := GameState.HERO
	return "%s\nLevel  %d\nHP     %d / %d\nMP     %d / %d\nEXP    %d\n\nATK %d   DEF %d   SPD %d" % [
		h.display_name, GameState.level, GameState.hp, h.max_hp, GameState.mp, h.max_mp,
		GameState.exp, h.attack, h.defense, h.speed]


func _quest_text() -> String:
	var quests := QuestManager.get_known_quests()
	if quests.is_empty():
		return "No quests yet.\n\nTalk to the villagers."
	var out := ""
	for q in quests:
		var state := QuestManager.get_state(q.id)
		var status := "Defeated %d/%d" % [QuestManager.get_progress(q.id), q.required_count]
		if state == QuestManager.State.READY_TO_TURN_IN:
			status = "Return to the quest giver"
		elif state == QuestManager.State.COMPLETED:
			status = "Complete"
		out += "%s\n%s\n%s\n\n" % [q.title, q.description, status]
	return out.strip_edges()

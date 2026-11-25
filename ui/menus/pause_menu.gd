extends Control

const ITEMS: Array[String] = ["Status", "Quests", "Boss music", "Items", "Resume"]

@onready var _list: ChoiceList = %MenuList
@onready var _info_panel: PanelContainer = %InfoPanel
@onready var _info: Label = %InfoText

var _open: bool = false
var _in_submenu: bool = false
var _mode: String = ""
var _bag: Array[StringName] = []
var _pick: StringName = &""


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
	_mode = ""
	_info_panel.hide()
	_list.set_choices(_items())
	_list.focus_first()


func _items() -> Array[String]:
	var out := ITEMS.duplicate()
	out[2] = "Boss music: %s" % ("Lyrics" if GameState.boss_music_lyrics else "Instrumental")
	return out


func _close_menu() -> void:
	_open = false
	_list.disarm()
	hide()
	await get_tree().create_timer(0.15).timeout
	if not _open:
		GameState.unlock(&"menu")


func _on_chosen(index: int) -> void:
	if _mode == "bag":
		if index >= _bag.size():
			_back_to_list()
			return
		_pick = _bag[index]
		_show_targets()
		return
	if _mode == "target":
		if index < GameState.party.size():
			var text := GameState.use_item(_pick, GameState.party[index])
			_show_bag()
			_info.text = text
		else:
			_show_bag()
		return
	match index:
		0:
			_show_info(_status_text())
		1:
			_show_info(_quest_text())
		2:
			GameState.set_boss_music_lyrics(not GameState.boss_music_lyrics)
			_list.set_choices(_items())
			(_list.get_child(2) as Button).grab_focus()
		3:
			_show_bag()
		4:
			_close_menu()


func _show_bag() -> void:
	_in_submenu = true
	_mode = "bag"
	_bag.clear()
	var names: Array[String] = []
	for i in GameState.ITEMS:
		if GameState.inventory.get(i.id, 0) > 0:
			_bag.append(i.id)
			names.append("%s  x%d" % [i.display_name, GameState.inventory[i.id]])
	names.append("Back")
	var keys: Array[String] = []
	for k in GameState.key_items:
		keys.append("%s: %s" % [GameState.KEY_ITEMS[k][0], GameState.KEY_ITEMS[k][1]])
	_info.text = "Buttons: %d\n\n%s\n\nKey items\n%s" % [GameState.buttons, "Pick an item to use it." if not _bag.is_empty() else "The bag is empty.", "\n".join(PackedStringArray(keys)) if not keys.is_empty() else "None yet."]
	_info_panel.show()
	_list.set_choices(names)
	_list.focus_first()


func _show_targets() -> void:
	_mode = "target"
	var names: Array[String] = []
	for id in GameState.party:
		var m := GameState.member(id)
		names.append("%s  %d/%d HP  %d/%d MP" % [m.display_name, GameState.get_hp(id), m.max_hp, GameState.get_mp(id), m.max_mp])
	names.append("Back")
	_info.text = "%s\n%s\n\nUse it on who?" % [GameState.item(_pick).display_name, GameState.item(_pick).description]
	_list.set_choices(names)
	_list.focus_first()


func _show_info(text: String) -> void:
	_in_submenu = true
	_info.text = text
	_info_panel.show()
	_list.set_choices(_items())
	_list.disarm()
	_list.focus_first()


func _status_text() -> String:
	var out := ""
	for id in GameState.party:
		var m := GameState.member(id)
		out += "%s\nHP %d/%d  MP %d/%d\nATK %d  DEF %d  SPD %d\n\n" % [m.display_name, GameState.get_hp(id), m.max_hp, GameState.get_mp(id), m.max_mp, m.attack, m.defense, m.speed]
	return out + "Level %d   EXP %d   Next %d\nButtons %d" % [GameState.level, GameState.exp, GameState.exp_to_next(), GameState.buttons]


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

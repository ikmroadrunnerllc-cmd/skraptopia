extends CanvasLayer

@onready var _toast: PanelContainer = %Toast
@onready var _toast_label: Label = %ToastLabel

var _queue: Array[String] = []
var _showing: bool = false


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_toast.hide()
	QuestManager.quest_started.connect(func(q: QuestData) -> void: notify("Quest accepted: %s" % q.title))
	QuestManager.quest_progressed.connect(func(q: QuestData, n: int) -> void: notify("%s  %d/%d" % [q.title, n, q.required_count]))
	QuestManager.quest_ready.connect(func(q: QuestData) -> void: notify("%s: return to the quest giver" % q.title))
	QuestManager.quest_completed.connect(func(q: QuestData) -> void: notify("Quest complete: %s  (+%d EXP)" % [q.title, q.reward_exp]))


func notify(text: String) -> void:
	_queue.append(text)
	if not _showing:
		_show_next()


func _show_next() -> void:
	if _queue.is_empty():
		_showing = false
		return
	_showing = true
	_toast_label.text = _queue.pop_front()
	_toast.modulate.a = 0.0
	_toast.show()
	var t := create_tween()
	t.tween_property(_toast, "modulate:a", 1.0, 0.2)
	t.tween_interval(2.2)
	t.tween_property(_toast, "modulate:a", 0.0, 0.3)
	await t.finished
	_toast.hide()
	_show_next()

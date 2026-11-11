extends Node
## Autoload "QuestManager": runtime quest progress keyed by stable quest id.

signal quest_started(quest: QuestData)
signal quest_progressed(quest: QuestData, count: int)
signal quest_ready(quest: QuestData)
signal quest_completed(quest: QuestData)

enum State { NOT_STARTED, ACTIVE, READY_TO_TURN_IN, COMPLETED }

var _defs: Dictionary = {}      # id -> QuestData
var _states: Dictionary = {}    # id -> State
var _progress: Dictionary = {}  # id -> int


func _ready() -> void:
	GameState.enemy_defeated.connect(_on_enemy_defeated)


func get_state(id: StringName) -> State:
	return _states.get(id, State.NOT_STARTED)


func get_progress(id: StringName) -> int:
	return _progress.get(id, 0)


func get_known_quests() -> Array[QuestData]:
	var out: Array[QuestData] = []
	for id: StringName in _defs:
		out.append(_defs[id])
	return out


func accept(quest: QuestData) -> void:
	if quest == null or get_state(quest.id) != State.NOT_STARTED:
		return
	_defs[quest.id] = quest
	_states[quest.id] = State.ACTIVE
	_progress[quest.id] = 0
	quest_started.emit(quest)


func complete(id: StringName) -> void:
	if get_state(id) != State.READY_TO_TURN_IN:
		return
	_states[id] = State.COMPLETED
	var quest: QuestData = _defs[id]
	GameState.add_exp(quest.reward_exp)
	quest_completed.emit(quest)


func _on_enemy_defeated(enemy_id: StringName) -> void:
	for id: StringName in _defs:
		var quest: QuestData = _defs[id]
		if get_state(id) != State.ACTIVE or quest.target_enemy_id != enemy_id:
			continue
		_progress[id] = mini(get_progress(id) + 1, quest.required_count)
		quest_progressed.emit(quest, _progress[id])
		if _progress[id] >= quest.required_count:
			_states[id] = State.READY_TO_TURN_IN
			quest_ready.emit(quest)

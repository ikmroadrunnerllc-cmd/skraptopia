extends CanvasLayer
## Autoload "Dialogue": classic bottom dialogue box with nameplate, typewriter text,
## "more" indicator and optional choices. `await Dialogue.play(data, name)` returns the
## chosen index, or -1 when there were no choices / the dialogue was aborted.

signal _step(value: int)

const CHARS_PER_SECOND := 45.0
const INPUT_GRACE_MS := 150

@onready var _root: Control = %DialogueRoot
@onready var _nameplate: PanelContainer = %Nameplate
@onready var _name: Label = %SpeakerName
@onready var _text: RichTextLabel = %DialogueText
@onready var _more: Label = %MoreIndicator
@onready var _choices: ChoiceList = %Choices
@onready var _choice_panel: PanelContainer = %ChoicePanel

var _active: bool = false
var _typing: bool = false
var _opened_ms: int = 0
var _blink: float = 0.0


func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	_root.hide()
	_choice_panel.hide()
	_choices.chosen.connect(func(i: int) -> void: _step.emit(i))


func is_active() -> bool:
	return _active


func play(data: DialogueData, default_speaker: String = "") -> int:
	if _active or data == null or data.lines.is_empty():
		return -1
	_active = true
	_opened_ms = Time.get_ticks_msec()
	GameState.lock(&"dialogue")
	var speaker := data.speaker if data.speaker != "" else default_speaker
	_name.text = speaker
	_nameplate.visible = speaker != ""
	_root.show()
	var result := -1
	for i in data.lines.size():
		var last := i == data.lines.size() - 1
		_show_line(data.lines[i])
		if last and not data.choices.is_empty():
			while _typing:
				await get_tree().process_frame
			if not _active:
				break
			_more.hide()
			_choices.set_choices(data.choices)
			_choice_panel.show()
			_choices.focus_first()
			result = await _step
			_choice_panel.hide()
		else:
			var r: int = await _step
			if r == -2:
				result = -1
				break
	_close()
	return result


## Ends any open dialogue immediately (used before scene changes).
func abort() -> void:
	if _active:
		_typing = false
		_step.emit(-2)
		_close()


func _close() -> void:
	if not _active:
		return
	_active = false
	_choices.disarm()
	_choice_panel.hide()
	_root.hide()
	# release the lock a moment later so the same key press cannot re-open a conversation
	await get_tree().create_timer(0.15).timeout
	if not _active:
		GameState.unlock(&"dialogue")


func _show_line(text: String) -> void:
	_text.text = text
	_text.visible_characters = 0
	_typing = true
	_more.hide()


func _process(delta: float) -> void:
	if not _active:
		return
	if _typing:
		var total := _text.get_total_character_count()
		_text.visible_characters = mini(_text.visible_characters + maxi(1, int(CHARS_PER_SECOND * delta + 0.5)), total)
		if _text.visible_characters >= total:
			_typing = false
	elif not _choice_panel.visible:
		_blink += delta
		_more.visible = fmod(_blink, 0.8) < 0.5


func _unhandled_input(event: InputEvent) -> void:
	if not _active or _choice_panel.visible:
		return
	if not (event.is_action_pressed("ui_accept") or event.is_action_pressed("interact")) or event.is_echo():
		return
	get_viewport().set_input_as_handled()
	if Time.get_ticks_msec() - _opened_ms < INPUT_GRACE_MS:
		return
	if _typing:
		_text.visible_characters = -1
		_typing = false
	else:
		_step.emit(0)

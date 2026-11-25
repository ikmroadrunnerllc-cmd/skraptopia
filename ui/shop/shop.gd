class_name Shop
extends CanvasLayer

signal closed

const FRAME: Texture2D = preload("res://assets/ui/retro_inventory/Inventory_9Slices.png")

var _stock: Array[ItemData] = []
var _list: ChoiceList
var _info: Label
var _wallet: Label


static func open(host: Node, stock: Array[ItemData]) -> void:
	var shop := Shop.new()
	shop._stock = stock
	host.get_tree().root.add_child(shop)
	await shop.closed


func _ready() -> void:
	layer = 20
	GameState.lock(&"shop")
	var style := StyleBoxTexture.new()
	style.texture = FRAME
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		style.set_texture_margin(side, 8)
		style.set_content_margin(side, 12)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", style)
	panel.position = Vector2(150, 90)
	panel.custom_minimum_size = Vector2(340, 180)
	add_child(panel)
	var col := VBoxContainer.new()
	panel.add_child(col)
	var title := Label.new()
	title.text = "Shop"
	col.add_child(title)
	_wallet = Label.new()
	col.add_child(_wallet)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	col.add_child(row)
	_list = ChoiceList.new()
	_list.vertical = true
	_list.custom_minimum_size.x = 170
	row.add_child(_list)
	_info = Label.new()
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info.custom_minimum_size = Vector2(140, 0)
	row.add_child(_info)
	_list.chosen.connect(_on_chosen)
	_fill()
	_info.text = "What would you like?"


func _fill(focus := 0) -> void:
	var names: Array[String] = []
	for i in _stock:
		names.append("%s  %d  (have %d)" % [i.display_name, i.price, GameState.inventory.get(i.id, 0)])
	names.append("Leave")
	_list.set_choices(names)
	for n in _stock.size():
		var b := _list.get_child(n) as Button
		b.icon = _stock[n].icon
		b.focus_entered.connect(func() -> void: _info.text = _stock[n].description)
	_wallet.text = "Buttons: %d" % GameState.buttons
	(_list.get_child(mini(focus, _stock.size())) as Button).grab_focus()


func _on_chosen(index: int) -> void:
	if index >= _stock.size():
		_close()
		return
	var i := _stock[index]
	if GameState.buy(i.id):
		_play("ui/shop_buy")
		_fill(index)
		_info.text = "You bought a %s!" % i.display_name
	else:
		_play("ui/denied")
		_fill(index)
		_info.text = "Not enough Buttons."


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_close()


func _play(id: String) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = load("res://assets/audio/game/sfx/%s.wav" % id)
	add_child(p)
	p.play()


func _close() -> void:
	_list.disarm()
	GameState.unlock(&"shop")
	closed.emit()
	queue_free()

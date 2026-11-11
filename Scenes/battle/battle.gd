extends Control
## Turn-based battle against GameState.pending_battle.enemy.
## BATTLE_START -> PLAYER_TURN -> ACTION_RESOLUTION -> ENEMY_TURN -> ... -> VICTORY / DEFEAT

enum State { BATTLE_START, PLAYER_TURN, ACTION_RESOLUTION, ENEMY_TURN, VICTORY, DEFEAT }
enum Command { ATTACK, DEFEND, SKILLS, ITEMS, RUN }

const COMMANDS: Array[String] = ["Attack", "Defend", "Skills", "Items", "Run"]
const DISABLED_COMMANDS: Array[int] = [Command.SKILLS, Command.ITEMS, Command.RUN]   # reserved for later
const STEP_TIME := 0.9
const FALLBACK_ENEMY: EnemyData = preload("res://data/enemies/slime.tres")

@onready var _enemy_sprite: TextureRect = %EnemySprite
@onready var _enemy_name: Label = %EnemyName
@onready var _enemy_hp: StatBar = %EnemyHP
@onready var _hero_name: Label = %HeroName
@onready var _hero_hp: StatBar = %HeroHP
@onready var _hero_mp: StatBar = %HeroMP
@onready var _commands: ChoiceList = %Commands
@onready var _message: Label = %Message
@onready var _result: PanelContainer = %ResultWindow
@onready var _result_title: Label = %ResultTitle
@onready var _result_text: Label = %ResultText
@onready var _result_choices: ChoiceList = %ResultChoices

var state: State = State.BATTLE_START
var enemy: EnemyData
var enemy_hp: int = 0          # runtime copy; the EnemyData resource is never modified
var _defending: bool = false
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	GameState.lock(&"battle")
	enemy = GameState.pending_battle.get("enemy", FALLBACK_ENEMY)
	enemy_hp = enemy.max_hp
	_result.hide()
	_commands.chosen.connect(_on_command)
	_result_choices.chosen.connect(_on_result_choice)
	_setup_view()
	_refresh()
	_start()


func _setup_view() -> void:
	_enemy_name.text = enemy.display_name
	_hero_name.text = GameState.HERO.display_name
	if enemy.sprite_sheet:
		var atlas := AtlasTexture.new()
		atlas.atlas = enemy.sprite_sheet
		var fw := enemy.sprite_sheet.get_width() / maxi(enemy.hframes, 1)
		var fh := enemy.sprite_sheet.get_height() / maxi(enemy.vframes, 1)
		atlas.region = Rect2(0, 0, fw, fh)
		_enemy_sprite.texture = atlas
	else:
		_enemy_sprite.texture = PlaceholderTexture2D.new()   # missing art must not crash


func _refresh() -> void:
	_enemy_hp.set_values(enemy_hp, enemy.max_hp)
	_hero_hp.set_values(GameState.hp, GameState.HERO.max_hp)
	_hero_mp.set_values(GameState.mp, GameState.HERO.max_mp)


func _start() -> void:
	_commands.set_choices(COMMANDS, DISABLED_COMMANDS)
	_commands.disarm()
	await _say("A wild %s appears!" % enemy.display_name)
	if enemy.speed > GameState.HERO.speed:
		await _enemy_turn()
	else:
		_player_turn()


func _player_turn() -> void:
	if state == State.VICTORY or state == State.DEFEAT:
		return
	state = State.PLAYER_TURN
	_defending = false
	_message.text = "What will %s do?" % GameState.HERO.display_name
	_commands.set_choices(COMMANDS, DISABLED_COMMANDS)
	_commands.focus_first()


func _on_command(index: int) -> void:
	if state != State.PLAYER_TURN:
		return
	state = State.ACTION_RESOLUTION   # commands are disarmed until the next player turn
	match index:
		Command.ATTACK:
			var dmg := _damage(GameState.HERO.attack, enemy.defense)
			enemy_hp = maxi(enemy_hp - dmg, 0)
			_flash(_enemy_sprite)
			_refresh()
			await _say("%s attacks! %s takes %d damage." % [GameState.HERO.display_name, enemy.display_name, dmg])
		Command.DEFEND:
			_defending = true
			await _say("%s is defending." % GameState.HERO.display_name)
	if enemy_hp <= 0:
		_victory()
	else:
		await _enemy_turn()


func _enemy_turn() -> void:
	state = State.ENEMY_TURN
	match enemy.ai:
		_:   # &"basic_attack" and any unknown behaviour fall back to a basic attack
			var dmg := _damage(enemy.attack, GameState.HERO.defense)
			if _defending:
				dmg = maxi(1, dmg / 2)
			GameState.set_hp(GameState.hp - dmg)
			_flash(_hero_hp)
			_refresh()
			await _say("%s attacks! %s takes %d damage." % [enemy.display_name, GameState.HERO.display_name, dmg])
	if GameState.hp <= 0:
		_defeat()
	else:
		_player_turn()


## attack - defence/2 with a little variance; never below 1.
func _damage(attack: int, defense: int) -> int:
	return maxi(1, attack - defense / 2 + _rng.randi_range(-1, 1))


func _victory() -> void:
	state = State.VICTORY
	GameState.add_exp(enemy.exp_reward)
	GameState.mark_defeated(GameState.pending_battle.get("encounter_id", ""), enemy.id)
	_show_result("Victory!", "%s was defeated.\n%s gained %d EXP." % [enemy.display_name, GameState.HERO.display_name, enemy.exp_reward], ["Continue"])


func _defeat() -> void:
	state = State.DEFEAT
	_show_result("Defeat...", "%s has fallen." % GameState.HERO.display_name, ["Retry battle", "Return to village"])


func _show_result(title: String, text: String, choices: Array[String]) -> void:
	_commands.set_choices(COMMANDS, DISABLED_COMMANDS)
	_commands.disarm()
	_result_title.text = title
	_result_text.text = text
	_result_choices.set_choices(choices)
	_result.show()
	_result_choices.focus_first()


func _on_result_choice(index: int) -> void:
	GameState.unlock(&"battle")
	if state == State.VICTORY:
		SceneManager.return_from_battle()
	elif index == 0:
		SceneManager.retry_battle()
	else:
		GameState.set_hp(GameState.HERO.max_hp)
		SceneManager.change_to(SceneManager.VILLAGE_SCENE, "FromField")


func _say(text: String) -> void:
	_message.text = text
	await get_tree().create_timer(STEP_TIME).timeout


func _flash(node: CanvasItem) -> void:
	var t := create_tween()
	t.tween_property(node, "modulate", Color(1, 0.4, 0.4), 0.08)
	t.tween_property(node, "modulate", Color.WHITE, 0.15)

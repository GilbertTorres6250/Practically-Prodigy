extends Node2D

@export var player_character: Character
@export var enemy_character: Character
var current_character : Character
@export var radial_menu : RadialMenu
@export var combat_log : Label
@export var shop_manager : ShopManager
var turn_count : int = 0
@export var shop_interval : int = 5
var game_over : bool = false
var permanent_moves : Array[CombatAction] = []

func save_permanent_deck():
	permanent_moves = player_character.moves.duplicate()

func restore_permanent_deck():
	if GameState.permanent_moves.is_empty():
		return
	player_character.moves = GameState.permanent_moves.duplicate()

func _ready():
	GameState.battle_count += 1
	enemy_character.roll_tier()
	restore_permanent_deck()
	GameState.permanent_moves = player_character.moves.duplicate()
	next_turn()

func end_battle():
	game_over = true
	player_character.moves = GameState.permanent_moves.duplicate()
	get_tree().change_scene_to_file("res://Scenes/PermanentShop.tscn")

func next_turn():
	if game_over:
		return
	
	if current_character != null:
		current_character.end_turn()
		if current_character.is_player:
			turn_count += 1
			if turn_count % shop_interval == 0:
				shop_manager.open_shop()
				return
	
	if current_character == enemy_character or current_character == null:
		current_character = player_character
	else:
		current_character = enemy_character
	
	current_character.begin_turn()
	
	if current_character.is_player:
		turn_count += 1
		if turn_count % shop_interval == 0:
			_give_enemy_cards()
			shop_manager.open_shop()
			return
		radial_menu.show_menu(player_character.moves)
	else:
		radial_menu.hide_menu()
		var wait_time = randf_range(0.5, 1.5)
		await get_tree().create_timer(wait_time).timeout
		var action_to_cast = enemy_turn()
		var log = enemy_character.commit_action(action_to_cast, player_character)
		combat_log.text = log
		await get_tree().create_timer(0.5).timeout
		next_turn()

func player_cast_move(action: CombatAction):
	if player_character != current_character:
		return
	if not is_instance_valid(enemy_character):
		return
	radial_menu.hide_menu()
	player_character.commit_action(action, enemy_character)
	if game_over:
		return
	await get_tree().create_timer(0.5).timeout
	next_turn()
	
func enemy_turn() -> CombatAction:
	print("enemy moves: ", enemy_character.moves.size())
	if enemy_character.moves.is_empty():
		return null
	return enemy_character.moves[randi() % enemy_character.moves.size()]

func _roll_enemy_card_count() -> int:
	var roll = randi() % 100
	match enemy_character.tier:
		1:
			if roll < 70:
				return 1
			elif roll < 95:
				return 2
			else:
				return 3
		2:
			if roll < 50:
				return 1
			elif roll < 85:
				return 2
			else:
				return 3
		3:
			if roll < 30:
				return 1
			elif roll < 70:
				return 2
			else:
				return 3
	return 1

func _give_enemy_cards():
	var count = _roll_enemy_card_count()
	for i in range(count):
		var move = shop_manager.available_moves[randi() % shop_manager.available_moves.size()]
		enemy_character.moves.append(move)
	print("Enemy gained %d card(s)" % count)

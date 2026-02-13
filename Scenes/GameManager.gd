extends Node2D

@export var player_character: Character
@export var enemy_character: Character
var current_character : Character

var game_over : bool = false

func _ready():
	next_turn()

func next_turn():
	if game_over:
		return
	
	if current_character != null:
		current_character.end_turn()
	
	if current_character == enemy_character or current_character == null:
		current_character = player_character
	else:
		current_character = enemy_character
	
	current_character.begin_turn()
	
	if current_character.is_player: #PLAYER TURN PLAYER TURN PLAYER TURN PLAYER TURN PLAYER TURN 
		pass
		#open ui
	else: #ENEMY TURN ENEMY TURN ENEMY TURN ENEMY TURN ENEMY TURN ENEMY TURN ENEMY TURN ENEMY TURN 
		#close ui
		var wait_time = randf_range(0.5,1.5)
		await get_tree().create_timer(wait_time).timeout
		
		var action_to_cast = enemy_turn()
		enemy_character.commit_action(action_to_cast, player_character)
		
		await get_tree().create_timer(0.5).timeout
		next_turn()

func player_cast_move(action : CombatAction):
	if player_character != current_character:
		return
	
	player_character.commit_action(action, enemy_character)
	#disable ui
	await get_tree().create_timer(0.5).timeout
	next_turn()

func enemy_turn() -> CombatAction:
	return null

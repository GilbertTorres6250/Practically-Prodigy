extends Node2D
class_name Character

@export var is_player : bool
@export var currentHealth : int = 25
@export var maxHealth : int = 25
var shield : int = 0

@export var moves : Array[CombatAction]
@export var target : Node
@export var tier : int = 1

@onready var healthBar : ProgressBar = get_node("Health Bar")
@onready var healthLabel : Label = get_node("Health Bar/Health Text")

var target_scale : float = 1.0

func _ready():
	healthBar.max_value = maxHealth
	print("build_menu called, move count: ", moves.size())


func take_damage(damage: int):
	if shield > 0:
		var absorbed = min(damage, shield)
		shield -= absorbed
		damage -= absorbed
	currentHealth -= damage
	_update_health_bar()
	if currentHealth <= 0:
		if not is_player:
			drop_coins()
			get_parent().end_battle()
		queue_free()
func heal(repair):
	currentHealth += repair

	if currentHealth >= maxHealth:
		currentHealth = maxHealth

	_update_health_bar()

func end_turn():
	target_scale = 0.9

func begin_turn():
	target_scale = 1.1
	if is_player:
		print("Player")
	else:
		print("Enemy")
		
func commit_action(action: CombatAction, target: Character) -> String:
	if action == null:
		return "Nothing happened"
	var level = moves.count(action)
	print("action: ", action.display_name, " level counted: ", level, " total moves: ", moves.size())
	var log_text = ""
	var damage = action.melee_damage * level
	var healing = action.heal_amount * level
	var shield_amt = action.shield_amount * level
	if damage > 0:
		target.take_damage(damage)
		log_text = "%s Lvl.%d, %d DMG" % [action.display_name, level, damage]
	if healing > 0:
		heal(healing)
		log_text = "%s Lvl.%d, %d HEAL" % [action.display_name, level, healing]
	if shield_amt > 0:
		self.shield += shield_amt
		log_text = "%s Lvl.%d, %d SHIELD" % [action.display_name, level, shield_amt]
	return log_text

func _update_health_bar():
	print("updating health bar, healthBar: ", healthBar, " value: ", currentHealth)
	healthBar.value = currentHealth
	healthLabel.text = str(currentHealth, "/", maxHealth)

func roll_tier():
	var battle = GameState.battle_count
	var weights = {}
	
	if battle <= 3:
		weights = {1: 100, 2: 0, 3: 0}
	elif battle <= 6:
		weights = {1: 70, 2: 30, 3: 0}
	else:
		weights = {1: 50, 2: 35, 3: 15}
	
	var roll = randi() % 100
	if roll < weights[1]:
		tier = 1
	elif roll < weights[1] + weights[2]:
		tier = 2
	else:
		tier = 3

func drop_coins():
	var amount = 0
	match tier:
		1: amount = randi_range(1, 2)
		2: amount = randi_range(2, 4)
		3: amount = randi_range(4, 7)
	GameState.coins += amount
	print("Enemy dropped %d coins! Total: %d" % [amount, GameState.coins])

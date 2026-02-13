extends Node2D
class_name Character

@export var is_player : bool
@export var currentHealth : int = 25
@export var maxHealth : int = 25

@export var moves : Array[CombatAction]
@export var target : Node

@onready var healthBar : ProgressBar = get_node("Health Bar")
@onready var healthLabel : Label = get_node("Health Bar/Health Text")

var target_scale : float = 1.0

func _ready():
	healthBar.max_value = maxHealth

func take_damage(damage):
	currentHealth -= damage
	_update_health_bar()
	
	if currentHealth <= 0:
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

func commit_action(CombatAction, target : Character):
	pass

func _update_health_bar():
	healthBar.value = currentHealth
	healthLabel.text = str(currentHealth,"/",maxHealth)

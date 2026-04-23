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

@export var sprite : Sprite2D
@onready var flash_effect : FlashEffect = $FlashEffect

var damage_number_scene = preload("res://DamageNumber.tscn")

var target_scale : float = 1.0

@onready var anim_effect : AnimationEffect = $AnimationEffect
@onready var particle_effect : ParticleEffect = $ParticleEffect

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
	_spawn_number(damage, false)
	flash_effect.flash(Color.RED)
	anim_effect.shake()
	particle_effect.play_damage()
	if currentHealth <= 0:
		if not is_player:
			drop_coins()
			get_parent().end_battle()
		queue_free()

func heal(repair: int):
	currentHealth += repair
	if currentHealth >= maxHealth:
		currentHealth = maxHealth
	_update_health_bar()
	_spawn_number(repair, true)
	flash_effect.flash(Color.GREEN)
	particle_effect.play_heal()

func _spawn_number(amount: int, is_heal: bool):
	var num = damage_number_scene.instantiate()
	get_parent().add_child(num)
	num.position = global_position + Vector2(randf_range(-20, 20), -40)
	num.setup(amount, is_heal)

func end_turn():
	target_scale = 0.9

var stunned : bool = false

func begin_turn():
	target_scale = 1.5
	if is_player:
		print("Player")
	else:
		print("Enemy")
		
func play_attack():
	anim_effect.bounce_attack()
	
func commit_action(action: CombatAction, combat_target: Character) -> String:
	if action == null:
		return "Nothing happened"
	
	var level = moves.count(action)
	var log_text = ""
	
	if action.primary_effect:
		log_text = _apply_effect(action.primary_effect, combat_target, level, action.display_name)
	
	if action.secondary_effect:
		var secondary_log = _apply_effect(action.secondary_effect, combat_target, level, action.display_name)
		if secondary_log != "":
			log_text += " / " + secondary_log
	
	return log_text

func _apply_effect(effect: CombatEffect, combat_target: Character, level: int, move_name: String) -> String:
	print("applying effect: ", effect.effect_type, " to: ", combat_target.name, " value: ", effect.base_value, " level: ", level)
	var chance = clamp(effect.base_chance + effect.chance_per_level * (level - 1), 0.0, 1.0)
	print("chance: ", chance)
	if randf() > chance:
		return "%s MISSED" % move_name
	
	var value = effect.base_value * level
	
	match effect.effect_type:
		CombatEffect.EffectType.DAMAGE:
			combat_target.take_damage(value)
			return "%s, %d DMG" % [move_name, value]
		
		CombatEffect.EffectType.HEAL:
			heal(value)
			return "%s, +%d HEAL" % [move_name, value]
		
		CombatEffect.EffectType.SHIELD:
			shield += value
			return "%s, +%d SHIELD" % [move_name, value]
		
		CombatEffect.EffectType.STUN:
			combat_target.stunned = true
			combat_target.flash_effect.flash_stun()
			return "%s, STUNNED" % move_name
		
		CombatEffect.EffectType.AOE_DAMAGE:
			# handled by BattleManager later when we add multi-enemy
			combat_target.take_damage(value)
			return "%s, %d AOE DMG" % [move_name, value]
	
	return ""

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

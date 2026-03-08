extends Control
class_name PermanentShop

@export var available_moves : Array[CombatAction]
@export var next_battle_scene : String = "res://Scenes/world.tscn"


var rarity_costs = {
	CombatAction.Rarity.COMMON: 1,
	CombatAction.Rarity.UNCOMMON: 2,
	CombatAction.Rarity.RARE: 4,
	CombatAction.Rarity.LEGENDARY: 8
}

var tier_cost_multiplier = { 1: 1, 2: 2, 3: 4 }

@onready var coin_label : Label = $CoinLabel
@onready var vbox : VBoxContainer = $VBoxContainer

func _ready():
	_build_shop()
	_update_coin_label()

func _build_shop():
	for child in vbox.get_children():
		child.queue_free()

	var offers = _roll_offers(5)

	for offer in offers:
		var tier = _roll_tier()
		var cost = _get_cost(offer, tier)

		var btn = Button.new()
		btn.text = "%s | %s x%d | %d coins" % [
			offer.display_name,
			CombatAction.Rarity.keys()[offer.rarity],
			tier,
			cost]
		btn.custom_minimum_size = Vector2(200, 50)

		var can_afford = GameState.coins >= cost
		btn.disabled = !can_afford

		btn.pressed.connect(func(): _on_offer_picked(offer, tier, cost, btn))
		vbox.add_child(btn)

	var leave_btn = Button.new()
	leave_btn.text = "Leave Shop"
	leave_btn.custom_minimum_size = Vector2(120, 40)
	leave_btn.pressed.connect(func(): _leave_shop())
	vbox.add_child(leave_btn)

func _roll_offers(count: int) -> Array[CombatAction]:
	var rarity_weights = {
		CombatAction.Rarity.COMMON: 60,
		CombatAction.Rarity.UNCOMMON: 25,
		CombatAction.Rarity.RARE: 12,
		CombatAction.Rarity.LEGENDARY: 3
	}
	var offers : Array[CombatAction] = []
	var pool = available_moves.duplicate()
	for i in range(min(count, pool.size())):
		var total = 0
		for move in pool:
			total += rarity_weights[move.rarity]
		var roll = randi() % total
		var cumulative = 0
		for move in pool:
			cumulative += rarity_weights[move.rarity]
			if roll < cumulative:
				offers.append(move)
				pool.erase(move)
				break
	return offers

func _roll_tier() -> int:
	var roll = randi() % 100
	if roll < 1:
		return 3
	elif roll < 20:
		return 2
	else:
		return 1

func _get_cost(move: CombatAction, tier: int) -> int:
	return rarity_costs[move.rarity] * tier_cost_multiplier[tier]

func _on_offer_picked(move: CombatAction, tier: int, cost: int, btn: Button):
	if GameState.coins < cost:
		return
	GameState.coins -= cost
	for i in range(tier):
		GameState.permanent_moves.append(move)
	btn.disabled = true
	btn.text = btn.text + " [BOUGHT]"
	_update_coin_label()
	_refresh_button_states()

func _refresh_button_states():
	for child in vbox.get_children():
		if child is Button and !child.text.ends_with("[BOUGHT]") and child.text != "Leave Shop":
			# re-check affordability
			child.disabled = true  # simplest approach: rebuild shop
	_build_shop()


func _update_coin_label():
	coin_label.text = "$%d" % GameState.coins

func _leave_shop():
	get_tree().change_scene_to_file(next_battle_scene)

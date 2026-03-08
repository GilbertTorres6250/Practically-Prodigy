extends Control
class_name ShopManager

@export var battle_manager : Node2D
@export var available_moves : Array[CombatAction]  # assign all possible moves in inspector

var rarity_weights = {
	CombatAction.Rarity.COMMON: 60,
	CombatAction.Rarity.UNCOMMON: 25,
	CombatAction.Rarity.RARE: 12,
	CombatAction.Rarity.LEGENDARY: 3
}

var tier_weights = { 1: 80, 2: 19, 3: 1 }

func open_shop():
	visible = true
	for child in get_children():
		child.queue_free()

	var hbox = HBoxContainer.new()
	add_child(hbox)

	for i in range(3):
		var offer = _roll_offer()
		var tier = _roll_tier()

		var btn = Button.new()
		btn.text = "%s\n%s  x%d" % [offer.display_name, CombatAction.Rarity.keys()[offer.rarity], tier]
		btn.custom_minimum_size = Vector2(120, 60)
		btn.pressed.connect(func(): _on_offer_picked(offer, tier))
		hbox.add_child(btn)

	var skip = Button.new()
	skip.text = "Skip"
	skip.custom_minimum_size = Vector2(120, 60)
	skip.pressed.connect(func(): _close_shop())
	hbox.add_child(skip)

func _roll_offer() -> CombatAction:
	var total = 0
	for move in available_moves:
		total += rarity_weights[move.rarity]
	var roll = randi() % total
	var cumulative = 0
	for move in available_moves:
		cumulative += rarity_weights[move.rarity]
		if roll < cumulative:
			return move
	return available_moves[0]

func _roll_tier() -> int:
	var roll = randi() % 100
	if roll < 1:
		return 3
	elif roll < 20:
		return 2
	else:
		return 1

func _on_offer_picked(move: CombatAction, tier: int):
	for i in range(tier):
		battle_manager.player_character.moves.append(move)
	battle_manager.radial_menu.build_menu(battle_manager.player_character.moves)
	_close_shop()

func _close_shop():
	visible = false
	battle_manager.next_turn()

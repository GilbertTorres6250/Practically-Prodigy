extends Node2D
class_name RadialMenu

@export var radius : float = 120.0
@export var battle_manager : Node2D

func build_menu(moves: Array[CombatAction]):
	print("build_menu called, move count: ", moves.size())
	# Clear old buttons
	for child in get_children():
		child.free()

	# Get unique moves and their levels
	var unique_moves : Array[CombatAction] = []
	for move in moves:
		if move not in unique_moves:
			unique_moves.append(move)

	var count = unique_moves.size()
	if count == 0:
		return

	for i in range(count):
		var angle = (2 * PI / count) * i - PI / 2  # start from top
		var pos = Vector2(cos(angle), sin(angle)) * radius

		var level = moves.count(unique_moves[i])

		var btn = Button.new()
		btn.text = "%s\nLvl.%d" % [unique_moves[i].display_name, level]
		btn.custom_minimum_size = Vector2(90, 50)
		btn.position = pos - btn.custom_minimum_size / 2  # center the button on the point

		var action = unique_moves[i]  # capture for lambda
		btn.pressed.connect(func(): _on_move_pressed(action))

		add_child(btn)

func _on_move_pressed(action: CombatAction):
	if battle_manager:
		battle_manager.player_cast_move(action)

func show_menu(moves: Array[CombatAction]):
	print("show_menu called")
	build_menu(moves)
	visible = true

func hide_menu():
	visible = false

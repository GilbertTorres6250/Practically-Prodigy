extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	print("Start Pressed")


func _settings_pressed() -> void:
	print("Settings Pressed")


func _quit_pressed() -> void:
	get_tree().quit()
	print("Quit Pressed")

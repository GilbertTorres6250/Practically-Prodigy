extends Node
class_name FlashEffect

@export var sprite : Sprite2D
var original_color : Color

func _ready():
	if sprite:
		original_color = sprite.modulate

func flash(color: Color):
	if not sprite:
		return
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", color, 0.05)
	tween.tween_property(sprite, "modulate", original_color, 0.15)
	
func flash_stun():
	if not sprite:
		return
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.YELLOW, 0.05)
	tween.tween_property(sprite, "modulate", Color.DARK_GOLDENROD, 0.1)
	tween.tween_property(sprite, "modulate", Color.YELLOW, 0.05)
	tween.tween_property(sprite, "modulate", original_color, 0.15)

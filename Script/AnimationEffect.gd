extends Node2D
class_name AnimationEffect

@export var sprite : Sprite2D

func shake():
	var tween = create_tween()
	var origin = sprite.position
	tween.tween_property(sprite, "position", origin + Vector2(6, 0), 0.05)
	tween.tween_property(sprite, "position", origin + Vector2(-6, 0), 0.05)
	tween.tween_property(sprite, "position", origin + Vector2(4, 0), 0.04)
	tween.tween_property(sprite, "position", origin + Vector2(-4, 0), 0.04)
	tween.tween_property(sprite, "position", origin, 0.03)

func bounce_attack():
	var tween = create_tween()
	var origin = sprite.position
	tween.tween_property(sprite, "position", origin + Vector2(0, -8), 0.08)
	tween.tween_property(sprite, "position", origin, 0.08)

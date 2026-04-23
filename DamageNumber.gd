extends Label
class_name DamageNumber

func setup(amount: int, is_heal: bool):
	if is_heal:
		text = "+%d" % amount
		modulate = Color.GREEN
	else:
		text = "-%d" % amount
		modulate = Color.RED
	
	add_theme_font_size_override("font_size", 36)
	add_theme_color_override("font_outline_color", Color.BLACK)
	add_theme_constant_override("outline_size", 6)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.8)
	tween.tween_property(self, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(queue_free)

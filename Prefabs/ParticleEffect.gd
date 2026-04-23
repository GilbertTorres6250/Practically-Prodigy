extends CPUParticles2D
class_name ParticleEffect

func _ready():
	emitting = false
	one_shot = true
	explosiveness = 0.8
	lifetime = 0.4
	amount = 12
	direction = Vector2(0, -1)
	spread = 45.0
	gravity = Vector2(0, 200)
	initial_velocity_min = 80.0
	initial_velocity_max = 150.0

func play_damage():
	modulate = Color.RED
	scale = Vector2(0.5, 0.5)
	emitting = true

func play_heal():
	modulate = Color.GREEN
	scale = Vector2(0.5, 0.5)
	emitting = true

func play_shield():
	modulate = Color.CYAN
	scale = Vector2(0.5, 0.5)
	emitting = true

func play_stun():
	modulate = Color.YELLOW
	scale = Vector2(0.5, 0.5)
	emitting = true

func play_fire():
	modulate = Color.ORANGE
	scale = Vector2(0.8, 0.8)
	amount = 20
	emitting = true

func play_ice():
	modulate = Color.LIGHT_BLUE
	scale = Vector2(0.8, 0.8)
	amount = 20
	emitting = true

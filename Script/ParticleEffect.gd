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

func play_burn():
	modulate = Color.ORANGE
	scale = Vector2(0.7, 0.7)
	amount = 18
	direction = Vector2(0, -1)
	spread = 30.0
	gravity = Vector2(0, -100)
	initial_velocity_min = 60.0
	initial_velocity_max = 100.0
	emitting = true

func play_drain():
	modulate = Color(0.4, 0.0, 0.8)
	scale = Vector2(0.6, 0.6)
	amount = 14
	direction = Vector2(0, -1)
	spread = 60.0
	gravity = Vector2(0, 50)
	initial_velocity_min = 40.0
	initial_velocity_max = 80.0
	emitting = true

func play_splash():
	modulate = Color(0.2, 0.6, 1.0)
	scale = Vector2(0.8, 0.8)
	amount = 20
	direction = Vector2(0, -1)
	spread = 90.0
	gravity = Vector2(0, 300)
	initial_velocity_min = 80.0
	initial_velocity_max = 140.0
	emitting = true

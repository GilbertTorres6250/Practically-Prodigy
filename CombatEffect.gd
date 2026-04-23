class_name CombatEffect
extends Resource

enum EffectType {
	DAMAGE,
	HEAL,
	SHIELD,
	STUN,
	AOE_DAMAGE,
}

@export var effect_type : EffectType = EffectType.DAMAGE
@export var base_value : int = 1
@export var base_chance : float = 1.0  # 1.0 = 100%, 0.5 = 50%
@export var chance_per_level : float = 0.0  # added chance per level

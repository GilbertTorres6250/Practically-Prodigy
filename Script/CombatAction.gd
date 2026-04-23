class_name CombatAction
extends Resource

enum Rarity { COMMON, UNCOMMON, RARE, LEGENDARY }

@export var display_name : String
@export var description : String
@export var rarity : Rarity = Rarity.COMMON
@export var base_weight : int = 100
@export var primary_effect : CombatEffect
@export var secondary_effect : CombatEffect

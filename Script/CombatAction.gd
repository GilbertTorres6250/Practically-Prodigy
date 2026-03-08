class_name CombatAction
extends Resource

enum Rarity { COMMON, UNCOMMON, RARE, LEGENDARY }

@export var display_name : String
@export var description : String
@export var melee_damage : int = 0
@export var heal_amount : int = 0
@export var shield_amount : int = 0
@export var base_weight : int = 100
@export var rarity : Rarity = Rarity.COMMON

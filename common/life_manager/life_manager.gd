extends Node

const MAX_LIVES: int = 15
var current_lives: int = MAX_LIVES
var life_potion_collected: bool = false

func reset() -> void:
	current_lives = MAX_LIVES

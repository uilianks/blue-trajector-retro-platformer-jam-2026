extends Control

@onready var container: HBoxContainer = $Panel/HBoxContainer

# Coloca aqui o caminho da tua textura de coração
const HEART_TEXTURE = preload("res://assets/hud elements/hearts_hud.png")

func _ready() -> void:
	BusSignals.player_died.connect(_on_player_died)
	BusSignals.life_updated.connect(_on_life_updated)
	_update_ui()

func _on_player_died() -> void:
	LifeManager.current_lives -= 1
	_update_ui()
	if LifeManager.current_lives <= 0:
		get_tree().change_scene_to_file("res://stages/game_over/game_over.tscn")
	else:
		get_tree().reload_current_scene()

func gain_life() -> void:
	LifeManager.current_lives = mini(LifeManager.current_lives + 1, LifeManager.MAX_LIVES)
	_update_ui()

func _update_ui() -> void:
	# Limpa os corações antigos
	for child in container.get_children():
		child.queue_free()

	# Cria um ícone por vida
	for i in LifeManager.current_lives:
		var heart := TextureRect.new()
		heart.texture = HEART_TEXTURE
		heart.custom_minimum_size = Vector2(32, 32)  # ajusta o tamanho
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		container.add_child(heart)

func _on_life_updated(current: int, _max_lives: int) -> void:
	_update_ui()

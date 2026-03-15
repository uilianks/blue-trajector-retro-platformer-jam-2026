extends Control

@onready var container: HBoxContainer = $Panel/HBoxContainer

const COIN_TEXTURE = preload("res://assets/hud elements/coins_hud.png")

func _ready() -> void:
	BusSignals.coin_updated.connect(_on_coin_updated)

func _on_coin_updated(collected: int, total: int) -> void:
	_update_ui(collected, total)

func _update_ui(collected: int, total: int) -> void:
	for child in container.get_children():
		child.queue_free()

	var remaining = total - collected  # moedas que ainda faltam pegar

	for i in remaining:
		var coin := TextureRect.new()
		coin.texture = COIN_TEXTURE
		coin.custom_minimum_size = Vector2(32, 32)
		coin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		container.add_child(coin)

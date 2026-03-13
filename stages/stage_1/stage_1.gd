extends Node

@onready var door: Node = $Door
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	BusSignals.collected.connect(_on_coin_collected)
	door.visible = false
	door.monitoring = false
	await get_tree().physics_frame
	_validate_coins()

func _on_coin_collected() -> void:
	await get_tree().physics_frame
	_validate_coins()

func _validate_coins() -> void:
	var coins := get_tree().get_nodes_in_group("coin")
	if coins.is_empty():
		print("[World] OK — nenhuma coin no mapa")
		door.visible = true
		door.monitoring = true
	else:
		print("[World] %d coin(s) restante(s)" % coins.size())

extends Node

@onready var door: Node = $Door
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var ui_press_space: Control = $UI/UiPressSpace

func _ready() -> void:
	BusSignals.collected.connect(_on_coin_collected)
	door.visible = false
	door.monitoring = false
	await get_tree().physics_frame
	_validate_coins()

func enable_interact() -> void:
	set_process_input(true)
	
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

var _used := false

func _input(event: InputEvent) -> void:
	if _used:
		return
	if event.is_action_pressed("ui_accept"):
		_used = true
		ui_press_space.queue_free()

class_name Platform extends AnimatableBody2D

@export var moving: bool = false
@export_enum("Horizontal", "Vertical") var direction: int = 0
@export var speed: float = 100.0
@export var range: float = 200.0

var _start_pos: Vector2
var _time: float = 0.0

func _ready() -> void:
	_start_pos = position

func _physics_process(delta: float) -> void:
	if not moving:
		return
	
	_time += delta * speed / range
	var offset = sin(_time) * range
	
	if direction == 0:
		position = _start_pos + Vector2(offset, 0)
	else:
		position = _start_pos + Vector2(0, offset)

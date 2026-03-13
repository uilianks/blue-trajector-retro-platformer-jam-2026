class_name PowerBar extends Node2D

@export var radius: float = 40.0
@export var pixel_size: float = 4.0

var _power: float = 0.0

func _ready() -> void:
	visible = false

func refresh(power: float) -> void:
	_power = power
	queue_redraw()

func _get_color() -> Color:
	if _power < 40.0:
		return Color("#1D9E75")
	elif _power < 70.0:
		return Color("#BA7517")
	return Color("#E24B4A")

func _draw() -> void:
	var steps := 24
	var filled := int((_power / 100.0) * steps)

	for i in steps:
		var angle := -PI / 2 + (float(i) / steps) * TAU
		var pos := Vector2(cos(angle), sin(angle)) * radius
		pos = (pos / pixel_size).floor() * pixel_size  # snapa no grid

		var color: Color
		if i < filled:
			color = _get_color()
		else:
			color = Color(1, 1, 1, 0.1)

		draw_rect(Rect2(pos - Vector2(pixel_size, pixel_size) / 2.0, Vector2(pixel_size, pixel_size)), color)

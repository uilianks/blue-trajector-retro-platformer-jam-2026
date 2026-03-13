class_name AngleBar extends Node2D

@export var max_angle_deg: float = 75.0
@export var arrow_length: float = 56.0
@export var pixel_size: float = 4.0
@export var arrow_color: Color = Color("#378ADD")

var _angle_rad: float = 0.0

func _ready() -> void:
	visible = false

func refresh(angle_t: float) -> void:
	var graus := ((angle_t - 50.0) / 50.0) * max_angle_deg
	_angle_rad = deg_to_rad(graus)
	queue_redraw()

func _draw() -> void:
	var dir := Vector2(sin(_angle_rad), -cos(_angle_rad))
	var steps := int(arrow_length / pixel_size)

	# corpo da seta em pixels
	for i in steps:
		var pos := dir * (i * pixel_size)
		pos = (pos / pixel_size).floor() * pixel_size
		draw_rect(Rect2(pos - Vector2(pixel_size, pixel_size) / 2.0, Vector2(pixel_size, pixel_size)), arrow_color)

	# cabeça da seta — 3 pixels em leque
	var tip := (dir * arrow_length / pixel_size).floor() * pixel_size
	var perp := Vector2(-dir.y, dir.x)
	for offset in [-1, 0, 1]:
		var head_pos: Vector2 = tip - dir * pixel_size * 2.0 + perp * pixel_size * float(offset)
		head_pos = (head_pos / pixel_size).floor() * pixel_size
		draw_rect(Rect2(head_pos - Vector2(pixel_size, pixel_size) / 2.0, Vector2(pixel_size, pixel_size)), arrow_color)

	# base
	draw_rect(Rect2(-Vector2(pixel_size, pixel_size) / 2.0, Vector2(pixel_size, pixel_size)), arrow_color)

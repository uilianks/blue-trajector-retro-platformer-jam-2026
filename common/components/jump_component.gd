class_name JumpComponent extends Node

@export var jump_force_max: float = 700.0
@export var jump_force_min: float = 100.0
@export var gravity: float = 1800.0
@export var bounce_min: float = 0.05
@export var bounce_max: float = 0.25
@onready var jump: AudioStreamPlayer = $"../../SFX/Jump"
@onready var charge: AudioStreamPlayer = $"../../SFX/Charge"

var _body: CharacterBody2D
var _sprite: AnimatedSprite2D
var _last_force: float = 0.0

func setup(body: CharacterBody2D, sprite: AnimatedSprite2D) -> void:
	_body = body
	_sprite = sprite

func physics_tick(delta: float, is_jumping: bool) -> bool:
	if not _body.is_on_floor():
		_body.velocity.y += gravity * delta

	if not is_jumping:
		return false

	_sprite.play("jump")
	
	var was_on_floor := _body.is_on_floor()
	_body.move_and_slide()

	for i in _body.get_slide_collision_count():
		var col = _body.get_slide_collision(i)
		var normal = col.get_normal()
		if abs(normal.x) > 0.7 and not was_on_floor:
			var bounce: float = clampf(_last_force / jump_force_max, bounce_min, bounce_max)
			_body.velocity.x = normal.x * _last_force * bounce

	if _body.is_on_floor() and _body.velocity.y >= 0:
		_sprite.play("idle")
		_body.velocity.x = 0.0
		return true  # sinaliza: pousou

	return false

func launch(force: float, angle_rad: float) -> void:
	jump.play()
	_last_force = force
	_body.velocity.x = sin(angle_rad) * force
	_body.velocity.y = -cos(angle_rad) * force

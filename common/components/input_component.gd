class_name ImputComponent extends Node


@export var power_speed: float = 90.0
@export var angle_speed: float = 80.0
@export var jump_force_max: float = 700.0
@export var jump_force_min: float = 100.0
@export var max_angle_deg: float = 75.0

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var power_bar: ProgressBar = $"../../UI/PowerBar"
@onready var angle_bar: ProgressBar = $"../../UI/AngleBar"

enum State { IDLE, CHARGING_POWER, CHARGING_ANGLE, JUMPING }
var state: State = State.IDLE
var power: float = 0.0
var angle_t: float = 50.0
var power_dir: float = 1.0
var angle_dir: float = 1.0

func tick(delta: float) -> void:
	match state:
		State.CHARGING_POWER:
			sprite.play("before_jump")
			power += power_dir * power_speed * delta
			if power >= 100.0:  power = 100.0; power_dir = -1.0
			elif power <= 0.0:  power = 0.0;   power_dir =  1.0
			power_bar.refresh(power)
		State.CHARGING_ANGLE:
			sprite.play("before_jump")
			angle_t += angle_dir * angle_speed * delta
			if angle_t >= 100.0:  angle_t = 100.0; angle_dir = -1.0
			elif angle_t <= 0.0:  angle_t = 0.0;   angle_dir =  1.0
			angle_bar.refresh(angle_t)

func on_accept_pressed(is_on_floor: bool) -> void:
	match state:
		State.IDLE:
			if not is_on_floor:
				return
			state = State.CHARGING_POWER
			power = 0.0; power_dir = 1.0
			power_bar.visible = true
			angle_bar.visible = false
			power_bar.refresh(power)
		State.CHARGING_POWER:
			state = State.CHARGING_ANGLE
			angle_t = 50.0; angle_dir = 1.0
			angle_bar.visible = true
			angle_bar.refresh(angle_t)
		State.CHARGING_ANGLE:
			power_bar.visible = false
			angle_bar.visible = false
			state = State.JUMPING
			var force := lerpf(jump_force_min, jump_force_max, power / 100.0)
			var angle_rad := deg_to_rad(((angle_t - 50.0) / 50.0) * max_angle_deg)
			BusSignals.jumped.emit(force, angle_rad)

func set_idle() -> void:
	state = State.IDLE

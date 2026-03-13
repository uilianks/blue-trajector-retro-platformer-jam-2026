extends CharacterBody2D

@export var jump_force_max: float = 700.0
@export var jump_force_min: float = 100.0
@export var power_speed: float = 90.0
@export var angle_speed: float = 80.0
@export var gravity: float = 1800.0
@export var max_angle_deg: float = 75.0
@export var bounce_min: float = 0.05
@export var bounce_max: float = 0.25
@onready var power_bar: ProgressBar = $PowerBar
@onready var angle_bar: ProgressBar = $AngleBar
@onready var label_power: Label     = $PowerBar/Label
@onready var label_angle: Label     = $AngleBar/Label
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum State { IDLE, CHARGING_POWER, CHARGING_ANGLE, JUMPING }
var state: State = State.IDLE
var power: float   = 0.0
var angle_t: float = 0.0
var power_dir: float = 1.0
var angle_dir: float = 1.0
var last_jump_force: float = 0.0

func _ready() -> void:
	animated_sprite_2d.play('idle')
	power_bar.min_value = 0
	power_bar.max_value = 100
	angle_bar.min_value = 0
	angle_bar.max_value = 100
	power_bar.visible = false
	angle_bar.visible = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	match state:
		State.CHARGING_POWER:
			animated_sprite_2d.play('before_jump')
			power += power_dir * power_speed * delta
			if power >= 100.0:
				power = 100.0; power_dir = -1.0
			elif power <= 0.0:
				power = 0.0; power_dir = 1.0
			_refresh_power_bar()
		State.CHARGING_ANGLE:
			animated_sprite_2d.play('before_jump')
			angle_t += angle_dir * angle_speed * delta
			if angle_t >= 100.0:
				angle_t = 100.0; angle_dir = -1.0
			elif angle_t <= 0.0:
				angle_t = 0.0; angle_dir = 1.0
			_refresh_angle_bar()
		State.JUMPING:
			animated_sprite_2d.play('jump')
			var was_on_floor := is_on_floor()
			move_and_slide()
			for i in get_slide_collision_count():
				var col = get_slide_collision(i)
				var normal = col.get_normal()
				if abs(normal.x) > 0.7 and not was_on_floor:
					var bounce_factor: float = clampf(last_jump_force / jump_force_max, bounce_min, bounce_max)
					velocity.x = normal.x * last_jump_force * bounce_factor
			if is_on_floor() and velocity.y >= 0:
				animated_sprite_2d.play('idle')
				velocity.x = 0.0
				state = State.IDLE
			return
	move_and_slide()

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept"):
		return
	match state:
		State.IDLE:
			if is_on_floor():
				state = State.CHARGING_POWER
				power = 0.0
				power_dir = 1.0
				power_bar.visible = true
				angle_bar.visible = false
				_refresh_power_bar()
		State.CHARGING_POWER:
			state = State.CHARGING_ANGLE
			angle_t = 50.0
			angle_dir = 1.0
			angle_bar.visible = true
			_refresh_angle_bar()
		State.CHARGING_ANGLE:
			power_bar.visible = false
			angle_bar.visible = false
			state = State.JUMPING
			var t_power: float = power / 100.0
			var force: float = lerpf(jump_force_min, jump_force_max, t_power)
			last_jump_force = force
			var t_angle: float = (angle_t - 50.0) / 50.0
			var angle_rad: float = deg_to_rad(t_angle * max_angle_deg)
			velocity.x = sin(angle_rad) * force
			velocity.y = -cos(angle_rad) * force

func _refresh_power_bar() -> void:
	power_bar.value = power
	var fill: StyleBoxFlat = power_bar.get_theme_stylebox("fill").duplicate()
	if power < 40.0:
		fill.bg_color = Color("#1D9E75")
	elif power < 70.0:
		fill.bg_color = Color("#BA7517")
	else:
		fill.bg_color = Color("#E24B4A")
	power_bar.add_theme_stylebox_override("fill", fill)
	if label_power:
		label_power.text = "%d%%" % int(power)

func _refresh_angle_bar() -> void:
	angle_bar.value = angle_t
	var fill: StyleBoxFlat = angle_bar.get_theme_stylebox("fill").duplicate()
	fill.bg_color = Color("#378ADD")
	angle_bar.add_theme_stylebox_override("fill", fill)
	if label_angle:
		var graus: float = ((angle_t - 50.0) / 50.0) * max_angle_deg
		label_angle.text = "%+.0f°" % graus

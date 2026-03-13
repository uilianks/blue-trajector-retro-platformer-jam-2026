extends ProgressBar

@onready var label: Label = $Label

@export var max_angle_deg: float = 75.0

func _ready() -> void:
	min_value = 0
	max_value = 100
	visible = false

func refresh(angle_t: float) -> void:
	value = angle_t
	var fill: StyleBoxFlat = get_theme_stylebox("fill").duplicate()
	fill.bg_color = Color("#378ADD")
	add_theme_stylebox_override("fill", fill)
	if label:
		var graus: float = ((angle_t - 50.0) / 50.0) * max_angle_deg
		label.text = "%+.0f°" % graus

extends ProgressBar

@onready var label: Label = $Label

func _ready() -> void:
	min_value = 0
	max_value = 100
	visible = false

func refresh(power: float) -> void:
	value = power
	var fill: StyleBoxFlat = get_theme_stylebox("fill").duplicate()
	if power < 40.0:
		fill.bg_color = Color("#1D9E75")
	elif power < 70.0:
		fill.bg_color = Color("#BA7517")
	else:
		fill.bg_color = Color("#E24B4A")
	add_theme_stylebox_override("fill", fill)
	if label:
		label.text = "%d%%" % int(power)

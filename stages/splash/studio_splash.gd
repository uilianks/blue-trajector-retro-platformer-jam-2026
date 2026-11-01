class_name StudioSplash
extends Control
## The studio logo on start-up: it fades in, the wombat blinks once, it fades out and the main menu follows.
## Any key, click or pad button skips it. The same splash as Garupa (Ratio Studio + "Powered by Godot
## Engine"), with the logo pre-scaled for the 640x320 frame.

@export var logo: TextureRect
## The "Powered by Godot" line; it fades with the logo.
@export var powered_by: Control
## Open eyes first, then half closed, then closed (the three cells of the logo sheet).
@export var frames: Array[Texture2D]
@export_file("*.tscn") var next_scene: String
@export var fade_in: float = 0.8
@export var hold: float = 1.6
@export var fade_out: float = 0.6
@export var blink_step: float = 0.09

var _leaving: bool = false


func _ready() -> void:
	logo.texture = frames[0]
	logo.modulate.a = 0.0
	powered_by.modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, fade_in)
	tween.parallel().tween_property(powered_by, "modulate:a", 1.0, fade_in)
	tween.tween_interval(hold * 0.5)
	# Half, closed, closed, half, open: a lazy blink that gives the still logo some life.
	for index: int in [1, 2, 2, 1, 0]:
		tween.tween_callback(_show_frame.bind(index))
		tween.tween_interval(blink_step)
	tween.tween_interval(hold * 0.5)
	tween.tween_property(logo, "modulate:a", 0.0, fade_out)
	tween.parallel().tween_property(powered_by, "modulate:a", 0.0, fade_out)
	tween.tween_callback(_leave)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo() or not event.is_pressed():
		return
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		_leave()


func _show_frame(index: int) -> void:
	logo.texture = frames[index]


# Called by the tween's end or by a skip; the guard keeps the second one from loading the scene twice.
func _leave() -> void:
	if _leaving:
		return
	_leaving = true
	get_tree().change_scene_to_file(next_scene)

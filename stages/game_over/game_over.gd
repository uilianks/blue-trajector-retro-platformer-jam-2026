extends Control

@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2

func _on_button_pressed() -> void:
	LifeManager.reset()
	get_tree().change_scene_to_file("res://stages/stage_1/stage_1.tscn")

func _on_button_2_pressed() -> void:
	get_tree().quit()

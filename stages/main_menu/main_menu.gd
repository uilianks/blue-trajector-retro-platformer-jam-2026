extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/stage_1/stage_1.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/credits/credits.tscn")

func _on_button_3_pressed() -> void:
	get_tree().quit()

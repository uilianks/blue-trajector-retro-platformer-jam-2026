class_name Door extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		get_tree().change_scene_to_file("res://stages/stage_2.tscn")

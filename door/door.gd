class_name Door extends Area2D

@export var next_stage: PackedScene

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if next_stage:
			get_tree().change_scene_to_packed(next_stage)

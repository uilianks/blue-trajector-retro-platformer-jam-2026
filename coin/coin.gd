extends Area2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $Node/AudioStreamPlayer

func _ready() -> void:
	animated_sprite_2d.play("idle")
	body_entered.connect(_on_body_entered)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		set_deferred("monitoring", false)
		audio_stream_player.play()
		animated_sprite_2d.play("picked")

func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "picked":
		BusSignals.collected.emit()
		queue_free()

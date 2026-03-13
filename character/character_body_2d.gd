extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_component: JumpComponent = $Components/JumpComponent
@onready var imput_component: ImputComponent = $Components/ImputComponent

func _ready() -> void:
	print('oi')
	sprite.play("idle")
	jump_component.setup(self, sprite)
	BusSignals.jumped.connect(jump_component.launch)
	
func _physics_process(delta: float) -> void:
	var is_jumping := imput_component.state == ImputComponent.State.JUMPING
	imput_component.tick(delta)
	var landed := jump_component.physics_tick(delta, is_jumping)
	if landed:
		imput_component.set_idle()
	if not is_jumping:
		move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		imput_component.on_accept_pressed(is_on_floor())

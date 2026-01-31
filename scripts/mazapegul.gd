extends Node3D

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
func _on_dialogic_signal(argument: String) -> void:
	if argument == "mazapegul":
		play_animation()

func play_animation() -> void:
	if Dialogic.VAR.mask_default:
		animated_sprite.play("idle")

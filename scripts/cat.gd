extends Node3D
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var prev_pos

func _ready() -> void:
	prev_pos = global_position

func _process(delta: float) -> void:
	if global_position != prev_pos:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	animated_sprite.flip_h = global_position.x > prev_pos.x
	prev_pos = global_position

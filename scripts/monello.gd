extends PathFollow3D
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var prev_pos

func _ready() -> void:
	prev_pos = global_position

func _process(delta: float) -> void:
	if global_position.z < prev_pos.z:
		animated_sprite.play("walk_back")
	elif global_position.z > prev_pos.z:
		animated_sprite.play("walk_front")
	else:
		animated_sprite.play("idle")

	animated_sprite.flip_h = global_position.x < prev_pos.x
	prev_pos = global_position

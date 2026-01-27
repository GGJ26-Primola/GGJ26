extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("right", "left", "up", "down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		rotation.y = input_dir.angle()
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack")

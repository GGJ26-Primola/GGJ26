extends Node3D

@onready var player: CharacterBody3D = $"../.."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var last_input: Vector2
#var last_direction: Vector3

func _physics_process(delta: float) -> void:
	
	if animation_player.is_playing():
		player.set_active(false)
		player.set_animation("idle")
		return
	else:
		player.set_active(true)
	
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack")
	
	var input_dir := Input.get_vector("up", "down", "left", "right")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var direction: Vector3
	
	if input_dir == Vector2.ZERO:
		input_dir = last_input
		#direction = last_direction
	else:
		last_input = input_dir
		#last_direction = direction
		#var input_dir := Input.get_vector("left", "right", "up", "down")
		#direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#if not animation_player.is_playing() and input_dir:
		#look_at(direction)
	rotation.y = input_dir.angle()

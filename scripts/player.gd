extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var animation_tree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite.play("jump_front")
		velocity.y = JUMP_VELOCITY
	
	elif is_on_floor():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			#change_animation(input_dir)
			animation_tree.set("parameters/Idle/blend_position", input_dir)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			animated_sprite.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func change_animation(direction: Vector2) -> void:
	if direction == Vector2.DOWN:
		animated_sprite.play("walk_down")
	elif direction == Vector2.UP:
		animated_sprite.play("walk_up")
	elif direction == Vector2.LEFT:
		animated_sprite.flip_h = false
		animated_sprite.play("walk_left")
	elif direction == Vector2.RIGHT:
		animated_sprite.flip_h = true
		animated_sprite.play("walk_left")

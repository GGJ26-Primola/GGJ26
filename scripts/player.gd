extends CharacterBody3D

# Images
#var idle_png = preload("res://assets/The Female Adventurer - Free/Idle/Idle.png")
#var walk_png = preload("res://assets/The Female Adventurer - Free/Walk/walk.png")
#var jump_png = preload("res://assets/The Female Adventurer - Free/Jump - NEW/Normal/Jump.png")

#var player_active: bool = true

const SPEED = 5.0
const STEP_DURATION = 0.3
#const JUMP_VELOCITY = 4.5

#@onready var animation_tree: AnimationTree = $AnimationTree
#@onready var idle_spreadsheet: Sprite3D = $idle_spreadsheet
@onready var step_player: AudioStreamPlayer = $StepPlayer
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var current_step_duration : float = 0
var last_y_direction : bool = false

#func set_active(is_active: bool) -> void:
#	player_active = is_active
	
#func set_animation(anim: String) -> void:
	#if anim == "idle":
		#idle_spreadsheet.texture = idle_png
	#elif anim == "walk":
		#idle_spreadsheet.texture = walk_png

func set_animation(directon: Vector2) -> void:
	var type_of_walking = "idle"
	var y_direction = "front" if last_y_direction == true else "back"
	if directon != Vector2.ZERO:
		animated_sprite.flip_h = directon.x < 0
		type_of_walking = "walk"
		if directon.y >= 0:
			last_y_direction = true
			y_direction = "front"
		else:
			last_y_direction = false
			y_direction = "back"
	animated_sprite.play(type_of_walking + "_" + y_direction)

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#idle_spreadsheet.texture = jump_png
		#velocity.y = JUMP_VELOCITY
	
	if not GameState.can_play():
		set_animation(Vector2.ZERO)
		return
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	set_animation(input_dir)
	
	if is_on_floor():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			
			#idle_spreadsheet.texture = walk_png
			#animation_tree.set("parameters/Idle/blend_position", input_dir)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			if current_step_duration <= 0:
				step_player.play()
				current_step_duration = STEP_DURATION
			
		else:
			#idle_spreadsheet.texture = idle_png
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	current_step_duration -= delta

	move_and_slide()

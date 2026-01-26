extends CharacterBody3D

var idle_png = preload("res://assets/The Female Adventurer - Free/Idle/Idle.png")
var walk_png = preload("res://assets/The Female Adventurer - Free/Walk/walk.png")
var jump_png = preload("res://assets/The Female Adventurer - Free/Jump - NEW/Normal/Jump.png")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var idle_spreadsheet: Sprite3D = $idle_spreadsheet

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		idle_spreadsheet.texture = jump_png
		velocity.y = JUMP_VELOCITY
	
	elif is_on_floor():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			idle_spreadsheet.texture = walk_png
			animation_tree.set("parameters/Idle/blend_position", input_dir)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			idle_spreadsheet.texture = idle_png
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

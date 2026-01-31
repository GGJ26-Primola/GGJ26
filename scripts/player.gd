extends CharacterBody3D

# Images
#var idle_png = preload("res://assets/The Female Adventurer - Free/Idle/Idle.png")
#var walk_png = preload("res://assets/The Female Adventurer - Free/Walk/walk.png")
#var jump_png = preload("res://assets/The Female Adventurer - Free/Jump - NEW/Normal/Jump.png")

@onready var game_manager: Node = %GameManager
@onready var step_player: AudioStreamPlayer = $StepPlayer
#@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var spreadsheet: Sprite3D = $spreadsheet
@onready var sprite_intro: AnimatedSprite3D = $SpriteIntro

var sprite_folder = "res://assets/2D/PG/"

const SPEED = 5.0
const STEP_DURATION = 0.3
#const JUMP_VELOCITY = 4.5

var current_step_duration : float = 0
var last_y_direction : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_intro.show()
	spreadsheet.hide()
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String) -> void:
	if argument == "intro_end":
		spreadsheet.show()
		sprite_intro.hide()

func set_animation(direction: Vector2) -> void:
	var type_of_walking = "Idle"
	#var y_direction = "front" if last_y_direction == true else "back"
	if direction != Vector2.ZERO and is_on_floor():
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
		type_of_walking = "Walk"
		
	spreadsheet.texture = load(sprite_folder + Dialogic.VAR.current_mask + "_spreadsheet.png")
	
	var animState = $AnimationTree.get("parameters/playback")
	animState.travel(type_of_walking)

func hitted() -> void:
	print("Game Over") #TODO

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		if position.y < -10:
			game_manager.respawn()
	
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

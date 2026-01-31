extends CharacterBody3D

@export var agro_range : float = 100.0
@export var speed : float = 300.0
@export var can_exit_agro := true
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

enum STATUS { IDLE, FOLLOW, RETURNING }
var current_status := STATUS.IDLE

var starting_point : Vector3
var min_distance_starting_point : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_point = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Global.player == null:
		return
	
	# If player enter agro, start follow
	if current_status == STATUS.IDLE or current_status == STATUS.RETURNING:
		var distance : Vector3 = Global.player.global_position - starting_point
		if distance.length_squared() < agro_range:
			current_status = STATUS.FOLLOW
			print("start follow")
	
	# If in follow
	if current_status == STATUS.FOLLOW:
		
		# If Player can exit agro, exit agro if distance from starting point
		if can_exit_agro:
			var distance : Vector3 = Global.player.global_position - starting_point
			if distance.length_squared() > agro_range:
				current_status = STATUS.RETURNING
				print("start returning")
				return
		
		# Move in the direction of player
		var distance : Vector3 = Global.player.global_position - global_position
		move_to_target(distance, delta)
	
	# if is returning
	if current_status == STATUS.RETURNING:
		var distance : Vector3 = starting_point - global_position
		if distance.length_squared() <= min_distance_starting_point:
			current_status = STATUS.IDLE
			print("start idle")
			return
		move_to_target(distance, delta)

func move_to_target(distance : Vector3, delta : float) -> void:
	#var direction = (transform.basis * Vector3(distance.x, 0, distance.y)).normalized()
	#if direction:
	distance = distance.normalized()
	velocity.x = distance.x * speed * delta
	velocity.z = distance.z * speed * delta
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()

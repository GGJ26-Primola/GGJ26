extends CharacterBody3D

@export var agro_range : float = 100.0
@export var respawn_time : float = 10.0
@export var speed : float = 350.0
@export var can_exit_agro := true
@export var can_die := true

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var respawn_timer: Timer = $RespawnTimer

enum STATUS { IDLE, FOLLOW, RETURNING }
var current_status := STATUS.IDLE

var starting_point : Vector3
var min_distance_starting_point : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_point = global_position
	respawn_timer.wait_time = respawn_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Global.player == null:
		return
	
	# If player enter agro, start follow
	if current_status == STATUS.IDLE or current_status == STATUS.RETURNING:
		var distance : Vector3 = Global.player.global_position - starting_point
		if distance.length_squared() < agro_range:
			current_status = STATUS.FOLLOW
			animated_sprite.play("attack")
	
	# If in follow
	if current_status == STATUS.FOLLOW:
		
		# If Player can exit agro, exit agro if distance from starting point
		if can_exit_agro:
			var distance : Vector3 = Global.player.global_position - starting_point
			if distance.length_squared() > agro_range:
				current_status = STATUS.RETURNING
				return
		
		# Move in the direction of player
		var distance : Vector3 = Global.player.global_position - global_position
		move_to_target(distance, delta)
	
	# if is returning
	if current_status == STATUS.RETURNING:
		var distance : Vector3 = starting_point - global_position
		if distance.length_squared() <= min_distance_starting_point:
			current_status = STATUS.IDLE
			animated_sprite.play("idle")
			return
		move_to_target(distance, delta)

func move_to_target(distance : Vector3, delta : float) -> void:
	animated_sprite.flip_h = distance.x > 0
	distance = distance.normalized()
	velocity.x = distance.x * speed * delta
	velocity.z = distance.z * speed * delta
	move_and_slide()

func hitted() -> void:
	respawn_timer.start()
	
func respawn() -> void:
	print("Enemy respwned")

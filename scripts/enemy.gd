extends CharacterBody3D

@export var agro_range : float = 100.0
@export var speed : float = 350.0
@export var damage_distance : float = 2.0
@export var can_exit_agro := true
@export var can_die := true

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var respawn_timer: Timer = $RespawnTimer

enum STATUS { IDLE, FOLLOW, RETURNING, HITTED, RESPAWNING }
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
	
	# If enemy hitted, do nothing
	if current_status == STATUS.HITTED:
		return
	
	# If waiting for respawn, respawn when player is outside agro
	if current_status == STATUS.RESPAWNING:
		if player_in_agro():
			return
		else:
			current_status = STATUS.IDLE
			animated_sprite.play("idle")
			animated_sprite.visible = true
	
	# If game status is not playing, do nothing
	if GameState.current_game_status != GameState.State.PLAYING:
		return
	
	# If player enter agro, start follow
	if current_status == STATUS.IDLE or current_status == STATUS.RETURNING:
		if player_in_agro():
			current_status = STATUS.FOLLOW
			animated_sprite.play("attack")
	
	# If in follow
	if current_status == STATUS.FOLLOW:
		
		# If Player can exit agro
		if can_exit_agro and not player_in_agro():
			current_status = STATUS.RETURNING
			return
		
		# Move in the direction of player
		var distance : Vector3 = Global.player.global_position - global_position
		
		# Hit player if is in damage distance
		if distance.length_squared() < damage_distance:
			hitted(null)
			Global.game_manager.game_over()
			return
		
		move_to_target(distance, delta)
	
	# if is returning
	if current_status == STATUS.RETURNING:
		var distance : Vector3 = starting_point - global_position
		if distance.length_squared() <= min_distance_starting_point:
			current_status = STATUS.IDLE
			animated_sprite.play("idle")
			return
		move_to_target(distance, delta)

func player_in_agro() -> bool:
	var distance : Vector3 = Global.player.global_position - starting_point
	return distance.length_squared() < agro_range

func move_to_target(distance : Vector3, delta : float) -> void:
	animated_sprite.flip_h = distance.x > 0
	distance = distance.normalized()
	velocity.x = distance.x * speed * delta
	velocity.z = distance.z * speed * delta
	velocity.y = distance.y * speed * delta
	move_and_slide()

func hitted(_area : Area3D) -> void:
	global_position = starting_point
	current_status = STATUS.HITTED
	animated_sprite.visible = false
	respawn_timer.start()
	
func respawn() -> void:
	current_status = STATUS.RESPAWNING

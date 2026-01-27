extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_player_1: AudioStreamPlayer = $"WeaponPlayer1"
@onready var weapon_player_2: AudioStreamPlayer = $"WeaponPlayer2"
@onready var collision_shape: CollisionShape3D = $Hitbox/CollisionShape3D

var last_input: Vector2
#var last_direction: Vector3

func end_attack() -> void:
	GameState.set_game_status(GameState.State.PLAYING)
	
func _ready() -> void:
	collision_shape.disabled = true

func _physics_process(delta: float) -> void:
	
	if not GameState.current_game_status == GameState.State.PLAYING:
		return
	
	if animation_player.is_playing():
		GameState.set_game_status(GameState.State.ATTACK)
		return
	
	if Input.is_action_just_pressed("attack"):
		
		# Play sound
		if randi_range(0, 1) == 0:
			weapon_player_1.play()
		else:
			weapon_player_2.play()
			
		animation_player.play("attack")
	
	var input_dir := Input.get_vector("up", "down", "left", "right")
	if input_dir == Vector2.ZERO:
		input_dir = last_input
	else:
		last_input = input_dir
	
	rotation.y = input_dir.angle()

extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_player_1: AudioStreamPlayer = $"WeaponPlayer1"
@onready var weapon_player_2: AudioStreamPlayer = $"WeaponPlayer2"

var input_dir : Vector2
var last_input : Vector2

func end_attack() -> void:
	if GameState.current_game_status == GameState.State.ATTACK:
		GameState.set_game_status(GameState.State.PLAYING)
	
func _physics_process(_delta: float) -> void:
	
	if not GameState.can_attack():
		return
	
	# Get direction (last if not pressed anything)
	input_dir = Input.get_vector("up", "down", "left", "right")
	if input_dir == Vector2.ZERO:
		input_dir = last_input
	else:
		last_input = input_dir
	
	# When attack
	if Input.is_action_just_pressed("dialogic_default_action"):
		
		GameState.set_game_status(GameState.State.ATTACK)
		
		# Play sound
		if randi_range(0, 1) == 0:
			weapon_player_1.play()
		else:
			weapon_player_2.play()
		
		# Change weapon direction
		rotation.y = input_dir.angle()
		
		# Play animation
		animation_player.play("attack")


func _on_hitbox_area_entered(area: Area3D) -> void:
	print(area)

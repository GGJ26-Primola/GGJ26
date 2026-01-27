extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var last_input: Vector2
#var last_direction: Vector3

func end_attack() -> void:
	GameState.set_game_status(GameState.State.PLAYING)

func _physics_process(delta: float) -> void:
	
	if not GameState.current_game_status == GameState.State.PLAYING:
		return
	
	if animation_player.is_playing():
		GameState.set_game_status(GameState.State.ATTACK)
		return
	
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack")
	
	var input_dir := Input.get_vector("up", "down", "left", "right")
	if input_dir == Vector2.ZERO:
		input_dir = last_input
	else:
		last_input = input_dir
	
	rotation.y = input_dir.angle()

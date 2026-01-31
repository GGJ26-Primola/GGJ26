extends Node
@onready var player: CharacterBody3D = %Player
@onready var graveyard_game_over: Control = $"../GraveyardGameOver"
@onready var camera_player: PhantomCamera3D = $"../CameraPlayer"
@onready var respawn_timer: Timer = $"../RespawnTimer"

var last_checkpoint: Vector3

func _ready() -> void:
	Global.game_manager = self
	Global.player = player
	Global.camera = camera_player
	
	last_checkpoint = player.global_position
	graveyard_game_over.hide()

func respawn() -> void:
	player.global_position = last_checkpoint
	
func game_over() -> void:
	GameState.set_game_status(GameState.State.GAMEOVER)
	graveyard_game_over.show()
	respawn_timer.start()

func cemetery_respawn() -> void:
	graveyard_game_over.hide()
	respawn()
	GameState.set_game_status(GameState.State.PLAYING)

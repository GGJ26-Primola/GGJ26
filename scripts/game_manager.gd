extends Node

@onready var camera_player: PhantomCamera3D = $CameraPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Dialogic.VAR.response = "test"
	GameState.set_game_status(GameState.State.PLAYING)
	Dialogic.timeline_ended.connect(GameState.end_talk)
	#Dialogic.signal_event.connect(_on_dialogic_signal)

#func _on_dialogic_signal(argument: String) -> void:
	#if argument == "stick":
		#GameState.take_stick()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if GameState.can_play() and Input.is_action_just_pressed("dialogic_default_action"):
		GameState.start_talk()

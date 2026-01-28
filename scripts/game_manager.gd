extends Node

@onready var camera_player: PhantomCamera3D = $CameraPlayer

#var game_status = GameState.State.PLAYING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Dialogic.VAR.response = "test"
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Dialogic.current_state == 0 and Input.is_action_just_pressed("lanterna"):
		Dialogic.start("timeline")

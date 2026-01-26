extends Node

@onready var camera_player: PhantomCamera3D = $CameraPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		camera_player.follow_offset = Vector3(0, 2, 2)
	else:
		camera_player.follow_offset = Vector3(0, 5, 5)

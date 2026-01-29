extends Node

#@onready var camera: Camera3D = %Camera3D
@onready var camera_player: PhantomCamera3D = $"../CameraPlayer"
@onready var umarell: CSGBox3D = $"../NPC/Umarell"
@onready var player: CharacterBody3D = %Player
var last_checkpoint := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.player = player
	Global.camera = camera_player
	
	GameState.set_game_status(GameState.State.PLAYING)
	Dialogic.timeline_started.connect(append_target)
	Dialogic.timeline_ended.connect(remove_target)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func append_target() -> void:
	camera_player.append_follow_targets(GameState.current_info_mark.get_parent().get_parent())

func remove_target() -> void:
	GameState.end_talk()
	camera_player.set_follow_targets([player])

func _on_dialogic_signal(argument: String) -> void:
	print("_on_dialogic_signal")
	if argument == "fov_0":
		camera_player.follow_offset = Vector3(0, 5, 5)
	elif argument == "fov_1":
		camera_player.follow_offset = Vector3(0, 4, 4)
	elif argument == "fov_2":
		camera_player.follow_offset = Vector3(0, 3, 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameState.can_talk() and Input.is_action_just_pressed("dialogic_default_action"):
		GameState.start_talk()

func respawn() -> void:
	player.position = last_checkpoint

func set_last_checkpoint(pos : Vector3) -> void:
	last_checkpoint = pos

func _on_umarell_attacked() -> void:
	Dialogic.VAR.umarell_hitted = true
	var tween = create_tween()
	tween.tween_property(umarell, "rotation_degrees:z", 90.0, 0.2)

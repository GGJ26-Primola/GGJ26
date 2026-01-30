extends Node

#@onready var camera: Camera3D = %Camera3D
@onready var camera_player: PhantomCamera3D = $"../CameraPlayer"
@onready var umarell: Node3D = $"../NPC/Umarell"
@onready var player: CharacterBody3D = %Player
var last_checkpoint := Vector3.ZERO

var cat_running = false
const RUN_SPEED = 5

@onready var cat_path: PathFollow3D = $"../NPC/CatPath3D/CatPathFollow3D"
@onready var child_1_path: PathFollow3D = $"../NPC/CatPath3D/PathFollow3D"
@onready var child_2_path: PathFollow3D = $"../NPC/CatPath3D/PathFollow3D2"

@onready var child_1_collision: CollisionShape3D = $"../NPC/CatPath3D/PathFollow3D/Destructible/CollisionShape3D"
@onready var child_2_collision: CollisionShape3D = $"../NPC/CatPath3D/PathFollow3D2/Destructible/CollisionShape3D"
@onready var cat_end_collision: CollisionShape3D = $"../NPC/CatPath3D/CatPathFollow3D/Interactible/CollisionShape3D"

@export var child_1_hitted_dialogue : DialogicTimeline
@export var child_2_hitted_dialogue : DialogicTimeline
@export var cat_end_dialogue : DialogicTimeline

# Cemetery
@onready var cemetery_death_audio : AudioStreamPlayer = $"../Musics/CemeteryDeathAudio"
@onready var cemetery_death_timer : Timer = $CemeteryDeathTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.player = player
	Global.camera = camera_player
	
	cat_end_collision.disabled = true
	child_1_collision.disabled = true
	child_2_collision.disabled = true
	
	GameState.set_game_status(GameState.State.PLAYING)
	Dialogic.timeline_started.connect(append_target)
	Dialogic.timeline_ended.connect(remove_target)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func append_target() -> void:
	if GameState.current_info_mark == null:
		return
	var new_target = GameState.current_info_mark.get_parent().get_parent()
	#camera_player.append_follow_targets(GameState.current_info_mark.get_parent().get_parent())
	if new_target != null:
		camera_player.set_follow_targets([player, new_target])
	else:
		camera_player.set_follow_targets([player])

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
	elif argument == "cat_start":
		start_cat()
	elif argument == "cat_stop":
		end_cat()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if GameState.current_game_status == GameState.State.GAMEOVER:
		return
	
	if GameState.can_talk() and Input.is_action_just_pressed("dialogic_default_action"):
		GameState.start_talk()
	run_paths(delta)
	
	# If you are in the cemetery without mask, you can live for few seconds
	if cemetery_death_timer.is_stopped():
		if Global.current_level == Global.Level.CEMETERY and not Dialogic.VAR.mask_cat:
			cemetery_death_audio.play()
			cemetery_death_timer.start()
	elif Dialogic.VAR.mask_cat:
		cemetery_death_audio.stop()
		cemetery_death_timer.stop()

func run_paths(delta) -> void:
	if not cat_running:
		return
	
	# If both child are defeated, set the final dialog available
	if child_1_path == null and child_2_path == null:
		cat_end_collision.disabled = false
		cat_running = false
		return
	
	if cat_path != null:
		cat_path.progress -= delta * RUN_SPEED
	if child_1_path != null:
		child_1_path.progress -= delta * RUN_SPEED
	if child_2_path != null:
		child_2_path.progress -= delta * RUN_SPEED

func respawn() -> void:
	player.position = last_checkpoint

func set_last_checkpoint(pos : Vector3) -> void:
	last_checkpoint = pos

func _on_umarell_attacked() -> void:
	Dialogic.VAR.umarell_hitted = true
	Dialogic.emit_signal("signal_event", "umarell")
	#var tween = create_tween()
	#tween.tween_property(umarell, "rotation_degrees:z", 90.0, 0.2)

func start_cat(start : bool = true) -> void:
	if child_1_collision != null:
		child_1_collision.disabled = not start
	if child_2_collision != null:
		child_2_collision.disabled = not start
	cat_running = start
	
func end_cat() -> void:
	start_cat(false)

func _on_item_attacked() -> void:
	print("HIT!")

func _on_child_1_attacked() -> void:
	print("HITTED CHILD 1")
	child_1_path.queue_free()
	start_timeline(child_1_hitted_dialogue)
	
func _on_child_2_attacked() -> void:
	print("HITTED CHILD 2")
	child_2_path.queue_free()
	start_timeline(child_2_hitted_dialogue)

func start_timeline(timeline : DialogicTimeline) -> void:
	GameState.set_game_status(GameState.State.TALKING)
	GameState.dialogic_reload_now = false
	GameState.dialogic_destroy_after_read = false
	Dialogic.start(timeline)

# TODO : CEMETERY
func cemetery_game_over() -> void:
	print("Cemetery game over")
	GameState.current_game_status = GameState.State.GAMEOVER

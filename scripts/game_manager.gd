extends Node

@onready var camera: Camera3D = %Camera3D
@onready var camera_player: PhantomCamera3D = $"../CameraPlayer"
@onready var umarell: Node3D = $"../NPC/Umarell"
@onready var player: CharacterBody3D = %Player
var last_checkpoint : Vector3

var cat_running = false
const RUN_SPEED = 5

const fov_default := Vector3(0, 5, 5)
const fov_1 := Vector3(0, 4, 4)
const fov_2 := Vector3(0, 3, 3)
const fov_boss := Vector3(0, 5, 10)

@onready var cat_path: PathFollow3D = $"../NPC/CatPath3D/CatPathFollow3D"
@onready var child_1_path: PathFollow3D = $"../NPC/CatPath3D/PathFollow3D"
@onready var child_2_path: PathFollow3D = $"../NPC/CatPath3D/PathFollow3D2"

@onready var child_1_collision: CollisionShape3D = $"../NPC/CatPath3D/PathFollow3D/Destructible/CollisionShape3D"
@onready var child_2_collision: CollisionShape3D = $"../NPC/CatPath3D/PathFollow3D2/Destructible/CollisionShape3D"
@onready var cat_end_collision: CollisionShape3D = $"../NPC/CatPath3D/CatPathFollow3D/Interactible/CollisionShape3D"

@export var child_1_hitted_dialogue : DialogicTimeline
@export var child_2_hitted_dialogue : DialogicTimeline
@export var cat_end_dialogue : DialogicTimeline

# Woods
@onready var skeleton_with_mask: Sprite3D = $"../NPC/ftp1_mask/SpriteWithMask"
@onready var skeleton_without_mask: Sprite3D = $"../NPC/ftp1_mask/SpriteWithoutMask"

# Cemetery
@onready var cemetery_death_audio : AudioStreamPlayer = $"../Musics/CemeteryDeathAudio"
@onready var cemetery_death_timer : Timer = $CemeteryDeathTimer
@onready var cemetery_respawn_timer: Timer = $CemeteryRespawnTimer
@onready var graveyard_game_over: Control = $"../GraveyardGameOver"
@onready var offence_label: Label = $"../GraveyardGameOver/MainPanel/VBoxContainer/Label2"
@onready var good_ghosts: Node3D = $"../GoodGhosts"
@onready var evils_ghosts: Node3D = $"../EvilsGhosts"

# BOSS
@onready var bossfight: Node3D = $"../Bossfight/CameraFocus"
@export var camera_shake_frequency: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.game_manager = self
	Global.player = player
	Global.camera = camera_player
	
	last_checkpoint = player.global_position
	
	cat_end_collision.disabled = true
	child_1_collision.disabled = true
	child_2_collision.disabled = true
	
	GameState.set_game_status(GameState.State.PLAYING)
	Dialogic.timeline_started.connect(append_target)
	Dialogic.timeline_ended.connect(remove_target)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	take_ftp1()
	
	graveyard_game_over.hide()
	
	if Dialogic.VAR.evil_item:
		good_ghosts.hide()
		evils_ghosts.show()
	else:
		destroyed_evil_item()

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
	if argument == "fov_0":
		camera_player.follow_offset = fov_default
	elif argument == "fov_1":
		camera_player.follow_offset = fov_1
	elif argument == "fov_2":
		camera_player.follow_offset = fov_2
	elif argument == "cat_start":
		start_cat()
	elif argument == "cat_stop":
		end_cat()
	elif argument == "take_ftp1":
		take_ftp1()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if GameState.current_game_status == GameState.State.GAMEOVER:
		return
	
	if GameState.can_talk() and Input.is_action_just_pressed("dialogic_default_action"):
		GameState.start_talk()
	run_paths(delta)
	
	# If you are in the cemetery without mask, you can live for few seconds
	if Dialogic.VAR.evil_item == false:
		return
	elif cemetery_death_timer.is_stopped():
		if Global.current_level == Global.Level.CEMETERY and not Dialogic.VAR.current_mask == "cat":
			cemetery_death_audio.play()
			cemetery_death_timer.start()
	elif Dialogic.VAR.current_mask == "cat" or Global.current_level != Global.Level.CEMETERY:
		cemetery_death_audio.stop()
		cemetery_death_timer.stop()
		
	mist_damage(delta)

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
	player.global_position = last_checkpoint

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

func game_over() -> void:
	camera_player.follow_offset = fov_default
	camera_player.set_follow_targets([player])
	camera.fov = 75
	
	Global.boss_agro = false
	GameState.set_game_status(GameState.State.GAMEOVER)
	offence_label.text = get_random_offence()
	graveyard_game_over.show()
	cemetery_respawn_timer.start()

# CEMETERY

func destroyed_evil_item() -> void:
	Dialogic.VAR.evil_item = false
	good_ghosts.show()
	evils_ghosts.queue_free()
	cemetery_death_audio.stop()
	cemetery_death_timer.stop()

func cemetery_game_over() -> void:
	Dialogic.VAR.dead_from_ghost = true
	game_over()
	
func cemetery_respawn() -> void:
	graveyard_game_over.hide()
	respawn()
	GameState.set_game_status(GameState.State.PLAYING)

func get_random_offence() -> String:
	var words = ["PATACCA", "SCIUPE", "QUAJON", "INVURNI", "INCICIUI", "SVARNAZA", "CIU", "IGNURANT"]
	return words[randi_range(0, len(words) - 1)]

## WOODS ##

func take_ftp1() -> void:
	if Dialogic.VAR.mask_ftp1:
		skeleton_with_mask.hide()
		skeleton_without_mask.show()
	else:
		skeleton_with_mask.show()
		skeleton_without_mask.hide()

## BOSSFIGHT ##

func mist_damage(delta: float) -> void:
	if not Global.mist_damage:
		camera_player.noise.frequency = 0
		return
	camera_player.noise.frequency = camera_shake_frequency

func enter_boss_agro(body: Node3D) -> void:
	if body.name == "Player":
		camera_player.follow_offset = fov_boss
		camera_player.set_follow_targets([player, bossfight])
		camera.fov = 90
		Global.boss_agro = true

func exit_boss_agro(body: Node3D) -> void:
	if body.name == "Player":
		camera_player.follow_offset = fov_default
		camera_player.set_follow_targets([player])
		camera.fov = 75
		Global.boss_agro = false

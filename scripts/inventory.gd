extends Control

@onready var container: HBoxContainer = $Mask/HBoxContainer
@onready var change_mask_audio: AudioStreamPlayer = $ChangeMaskAudio

var inventory_size : int
var current_item : float
const initial_position = 384.5

func _ready() -> void:
	hide()
	inventory_size = container.get_child_count()
	set_current_item()
	container.position.x = initial_position - current_item * 98
	display_mask()
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String) -> void:
	if argument == "inventory":
		display_mask()

func set_current_item() -> void:
	if Dialogic.VAR.current_mask == "default":
		current_item = 1.0
	elif Dialogic.VAR.current_mask == "cat":
		current_item = 2.0
	elif Dialogic.VAR.current_mask == "ftp1":
		current_item = 3.0
	elif Dialogic.VAR.current_mask == "pest":
		current_item = 4.0
	elif Dialogic.VAR.current_mask == "boss":
		current_item = 5.0

func equip_mask() -> void:
	if current_item == 1 and Dialogic.VAR.mask_default:
		Dialogic.VAR.current_mask = "default"
	elif current_item == 2 and Dialogic.VAR.mask_cat:
		Dialogic.VAR.current_mask = "cat"
	elif current_item == 3 and Dialogic.VAR.mask_ftp1:
		Dialogic.VAR.current_mask = "ftp1"
	elif current_item == 4 and Dialogic.VAR.mask_pest:
		Dialogic.VAR.current_mask = "pest"
	elif current_item == 5 and Dialogic.VAR.mask_boss:
		Dialogic.VAR.current_mask = "boss"
	else:
		return
	
	change_mask_audio.play()
	GameState.current_game_status = GameState.State.PLAYING
	hide()

func move_container() -> void:
	var tween = create_tween()
	tween.tween_property(container, "position:x",
	 initial_position - current_item * 98, 0.2)

func display_mask() -> void:
	container.get_child(0).get_child(1).visible = not Dialogic.VAR.mask_default
	container.get_child(1).get_child(1).visible = not Dialogic.VAR.mask_cat
	container.get_child(2).get_child(1).visible = not Dialogic.VAR.mask_ftp1
	container.get_child(3).get_child(1).visible = not Dialogic.VAR.mask_pest
	container.get_child(4).get_child(1).visible = not Dialogic.VAR.mask_boss
	
	container.get_child(0).get_child(0).visible = Dialogic.VAR.mask_default
	container.get_child(1).get_child(0).visible = Dialogic.VAR.mask_cat
	container.get_child(2).get_child(0).visible = Dialogic.VAR.mask_ftp1
	container.get_child(3).get_child(0).visible = Dialogic.VAR.mask_pest
	container.get_child(4).get_child(0).visible = Dialogic.VAR.mask_boss

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("inventory"):
		if GameState.can_inventory():
			show()
			GameState.current_game_status = GameState.State.INVENTORY
		elif GameState.current_game_status == GameState.State.INVENTORY:
			hide()
			GameState.current_game_status = GameState.State.PLAYING
	
	if GameState.current_game_status != GameState.State.INVENTORY:
		return
	
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		var direction = Input.get_axis("left","right")
		direction = sign(direction)
		var temp_item = current_item + direction
		temp_item = wrapi(temp_item, 1, inventory_size+1)
		current_item = temp_item
		#if temp_item < 1 or temp_item > inventory_size:
			#return
		#current_item += direction
		move_container()
	elif Input.is_action_just_pressed("dialogic_default_action"):
		equip_mask()

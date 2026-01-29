extends Control
@onready var container: HBoxContainer = $Mask/HBoxContainer
var inventory_size : int
var current_item : float
const initial_position = 384.5

func _ready() -> void:
	inventory_size = container.get_child_count()
	set_current_item()
	container.position.x = initial_position - current_item * 98
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


func move_container() -> void:
	var tween = create_tween()
	tween.tween_property(container, "position:x",
	 initial_position - current_item * 98, 0.2)

func display_mask() -> void:
	#TODO: seleziona mascherina (se disponibile) -> Dialogic
	container.get_child(0).get_child(0).visible = Dialogic.VAR.mask_default
	container.get_child(1).get_child(0).visible = Dialogic.VAR.mask_cat
	container.get_child(2).get_child(0).visible = Dialogic.VAR.mask_ftp1
	container.get_child(3).get_child(0).visible = Dialogic.VAR.mask_pest
	container.get_child(4).get_child(0).visible = Dialogic.VAR.mask_boss

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		var direction = Input.get_axis("left","right")
		var temp_item = current_item + direction
		if temp_item < 1 or temp_item > inventory_size:
			return
		current_item += direction
		move_container()

func select_item() -> void:
	if current_item == 1 and Dialogic.VAR.mask_default:
		#TODO: seleziona mascherina (se disponibile) -> Dialogic
		pass
	elif current_item == 2 and Dialogic.VAR.mask_cat:
		pass

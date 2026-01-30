extends Control

@onready var main_panel: NinePatchRect = $MainPanel
@onready var options_panel: NinePatchRect = $OptionsPanel

@onready var play_button: MenuButton = $MainPanel/VBoxContainer/NinePatchRect/PlayButton
@onready var back_button: MenuButton = $OptionsPanel/VBoxContainer/NinePatchRect3/BackButton

var current_item = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_panel.hide()
	options_panel.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		
		if GameState.current_game_status == GameState.State.ATTACK:
			return
		elif GameState.current_game_status == GameState.State.TALKING:
			return
		elif GameState.current_game_status == GameState.State.INVENTORY:
			return
		elif GameState.current_game_status == GameState.State.PAUSE:
			_on_play_button_pressed()
		else:
			GameState.set_game_status(GameState.State.PAUSE)
			main_panel.show()
			options_panel.hide()
			
			# TODO: WORK, but the menu is not working in the scene right now
			play_button.focus_mode = Control.FOCUS_ALL
			play_button.grab_focus()
			current_item = 0
			
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		var focused 
		var active = options_panel if options_panel.visible else main_panel
		var direction = Input.get_axis("up","down")
		direction = sign(direction)
		if main_panel.visible:
			current_item = wrapi(current_item + direction, 0, active.get_child(0).get_child_count()-1)
			focused = active.get_child(0).get_child(current_item+1).get_child(0)
			
		elif options_panel.visible:
			current_item = wrapi(current_item + direction, 0, 4)
			if current_item == 3:
				focused = active.get_child(0).get_child(2).get_child(0)
			else:
				focused = active.get_child(0).get_child(1).get_child(1).get_child(current_item)
				
		if focused != null:
			focused.focus_mode = Control.FOCUS_ALL
			focused.grab_focus()

func _on_play_button_pressed() -> void:
	GameState.set_game_status(GameState.State.PLAYING)
	main_panel.hide()
	options_panel.hide()

func _on_options_button_pressed() -> void:
	main_panel.hide()
	options_panel.show()
	back_button.focus_mode = Control.FOCUS_ALL
	back_button.grab_focus()
	current_item = 3

func _on_exit_button_pressed() -> void:
	get_tree().quit() #Exit game

func _on_back_button_pressed() -> void:
	main_panel.show()
	options_panel.hide()
	play_button.focus_mode = Control.FOCUS_ALL
	play_button.grab_focus()

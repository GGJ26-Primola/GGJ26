extends Control

@onready var player: CharacterBody3D = %Player
@onready var main_panel: NinePatchRect = $MainPanel
@onready var options_panel: NinePatchRect = $OptionsPanel
@onready var play_button: MenuButton = $MainPanel/VBoxContainer/NinePatchRect/PlayButton

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
			#play_button.f
			options_panel.hide()

func _on_play_button_pressed() -> void:
	GameState.set_game_status(GameState.State.PLAYING)
	main_panel.hide()
	options_panel.hide()

func _on_options_button_pressed() -> void:
	main_panel.hide()
	options_panel.show()

func _on_exit_button_pressed() -> void:
	get_tree().quit() #Exit game

func _on_back_button_pressed() -> void:
	main_panel.show()
	options_panel.hide()

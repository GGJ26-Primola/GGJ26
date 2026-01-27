extends Control

@onready var player: CharacterBody3D = %Player
@onready var main_panel: Panel = $MainPanel
@onready var options_panel: Panel = $OptionsPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_panel.hide()
	options_panel.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if main_panel.visible or options_panel.visible:
			_on_play_button_pressed()
		else:
			GameState.set_game_status(GameState.State.PAUSE)
			main_panel.show()
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

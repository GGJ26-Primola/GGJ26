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
			player.set_active(false)
			main_panel.show()
			options_panel.hide()

func _on_play_button_pressed() -> void:
	player.set_active(true)
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

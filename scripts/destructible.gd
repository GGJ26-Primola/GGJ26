extends Area3D

signal attacked

@export var timeline : DialogicTimeline
@export var destroy_parent := false

func _on_area_entered(_area: Area3D) -> void:
	
	if GameState.current_game_status != GameState.State.ATTACK:
		return
	
	attacked.emit()
	
	if timeline != null:
		GameState.set_game_status(GameState.State.TALKING)
		Dialogic.start(timeline)
	
	if destroy_parent:
		get_parent().queue_free()

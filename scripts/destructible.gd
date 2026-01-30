extends Area3D

signal attacked

@export var timeline : DialogicTimeline

func _on_area_entered(_area: Area3D) -> void:
	attacked.emit()
	if timeline != null:
		GameState.set_game_status(GameState.State.TALKING)
		Dialogic.start(timeline)
	queue_free()

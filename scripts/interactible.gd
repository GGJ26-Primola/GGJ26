extends Area3D

@export var timeline : DialogicTimeline
@onready var info_mark: Sprite3D = $InfoMark

func _ready() -> void:
	info_mark.hide()

func _on_area_entered(area: Area3D) -> void:
	print("_on_area_entered: " + area.name)
	info_mark.show()
	GameState.set_dialogic_timeline(timeline, info_mark)

func _on_area_exited(area: Area3D) -> void:
	print("_on_area_exited: " + area.name)
	info_mark.hide()
	GameState.set_dialogic_timeline(null, null)

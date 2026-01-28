extends Area3D

@export var timeline : DialogicTimeline
@export var bubble_pnc : DialogicCharacter

@onready var info_mark: Sprite3D = $InfoMark

var layout

func _ready() -> void:
	info_mark.hide()

func _on_area_entered(area: Area3D) -> void:
	#print("_on_area_entered: " + area.name)
	
	if bubble_pnc != null:
		layout = Dialogic.Styles.load_style("bubble")
		layout.register_character(bubble_pnc, $".")
	info_mark.show()
	GameState.set_dialogic_timeline(timeline, info_mark)

func _on_area_exited(area: Area3D) -> void:
	#print("_on_area_exited: " + area.name)
	info_mark.hide()
	GameState.set_dialogic_timeline(null, null)

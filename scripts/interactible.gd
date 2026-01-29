extends Area3D

@export var timeline : DialogicTimeline
@export var bubble_pnc : DialogicCharacter
@export var automatic_play : bool = false
@export var reload_now : bool = false
#@export var destroy_after_read : bool = false

@onready var info_mark: Sprite3D = $InfoMark

var layout

func _ready() -> void:
	info_mark.hide()

func _on_area_entered(area: Area3D) -> void:
	
	if bubble_pnc != null:
		layout = Dialogic.Styles.load_style("bubble")
		layout.register_character(bubble_pnc, $".")
	else:
		Dialogic.Styles.load_style("conversation")
	
	info_mark.show()
	#GameState.set_dialogic_timeline(timeline, info_mark)
	GameState.dialogic_timeline = timeline
	GameState.current_info_mark = info_mark
	GameState.dialogic_reload_now = reload_now
	
	if automatic_play and GameState.can_play():
		GameState.start_talk()

func _on_area_exited(area: Area3D) -> void:
	info_mark.hide()
	GameState.dialogic_timeline = null
	GameState.current_info_mark = null
	#GameState.set_dialogic_timeline(null, null, false)

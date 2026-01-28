class_name GameState

enum State { PLAYING, PAUSE, ATTACK, TALKING, GAMEOVER }

static var dialogic_timeline : DialogicTimeline = null
static var current_game_status = GameState.State.PLAYING
static var current_info_mark : Sprite3D = null
static var has_stick : bool = false

static func set_game_status(status_to_set: GameState.State) -> void:
	current_game_status = status_to_set

#static func take_stick() -> void:
	#has_stick = true

static func can_play() -> bool:
	return Dialogic.current_state == 0 and GameState.current_game_status == GameState.State.PLAYING

static func can_talk() -> bool:
	return dialogic_timeline != null and current_info_mark != null

static func can_attack() -> bool:
	if not Dialogic.VAR.stick: # has_stick == false:
		return false
	if can_talk():
		return false
	return Dialogic.current_state == 0 and GameState.current_game_status == GameState.State.PLAYING

static func set_dialogic_timeline(timeline_name, info_mark: Sprite3D) -> void:
	dialogic_timeline = timeline_name
	if current_info_mark != null:
		current_info_mark.hide()
	current_info_mark = info_mark

static func start_talk():
	if can_talk():
		current_game_status = GameState.State.TALKING
		Dialogic.start(dialogic_timeline)
		dialogic_timeline = null
		current_info_mark.hide()

static func end_talk():
	current_game_status = GameState.State.PLAYING
	dialogic_timeline = null
	current_info_mark = null

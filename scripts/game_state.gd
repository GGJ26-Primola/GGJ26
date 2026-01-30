class_name GameState

enum State { PLAYING, PAUSE, INVENTORY, ATTACK, TALKING, GAMEOVER }

static var current_game_status := GameState.State.PLAYING

# Dialogic stuff
static var dialogic_timeline : DialogicTimeline = null
static var current_info_mark : Sprite3D = null
static var dialogic_reload_now : bool = false
static var dialogic_destroy_after_read : bool = false

static func set_game_status(status_to_set: GameState.State) -> void:
	current_game_status = status_to_set

static func can_play() -> bool:
	return Dialogic.current_state == 0 and GameState.current_game_status == GameState.State.PLAYING

static func can_inventory() -> bool:
	if Dialogic.current_state != 0:
		return false
	if GameState.current_game_status != GameState.State.PLAYING:
		return false
	return Dialogic.VAR.mask_cat or Dialogic.VAR.mask_ftp1 or Dialogic.VAR.mask_pest or Dialogic.VAR.mask_boss

static func can_talk() -> bool:
	if GameState.current_game_status != GameState.State.PLAYING:
		return false
	return dialogic_timeline != null # and current_info_mark != null

static func can_attack() -> bool:
	if not Dialogic.VAR.stick:
		return false
	if can_talk():
		return false
	return Dialogic.current_state == 0 and GameState.current_game_status == GameState.State.PLAYING

#static func set_dialogic_timeline(timeline_name, info_mark: Sprite3D) -> void:
	#dialogic_timeline = timeline_name
	#if current_info_mark != null:
		#current_info_mark.hide()
	#current_info_mark = info_mark

static func start_talk():
	if can_talk():
		
		set_game_status(GameState.State.TALKING)
		Dialogic.start(dialogic_timeline)
		if current_info_mark != null:
			current_info_mark.hide()

static func end_talk():
	set_game_status(GameState.State.PLAYING)
	if dialogic_reload_now:
		if current_info_mark != null:
			current_info_mark.show()
		return
	
	if dialogic_destroy_after_read and current_info_mark:
		current_info_mark.get_parent().get_parent().queue_free()
	
	dialogic_timeline = null
	current_info_mark = null

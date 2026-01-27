class_name GameState

enum State { PLAYING, PAUSE, ATTACK, GAMEOVER }

static var current_game_status = GameState.State.PLAYING

static func set_game_status(status_to_set: GameState.State) -> void:
	current_game_status = status_to_set

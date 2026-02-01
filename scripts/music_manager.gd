extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var current_music = "safe"

func change_music(music_name: String) -> void:
	if current_music != music_name:
		current_music = music_name
		audio_stream_player.get_stream_playback().switch_to_clip_by_name(music_name)
		if music_name == "safe":
			Global.current_level = Global.Level.SAFE
			Dialogic.emit_signal("fov_0")
		elif music_name == "cemetery":
			Global.current_level = Global.Level.CEMETERY
			Dialogic.emit_signal("fov_0")
		elif music_name == "woods":
			Global.current_level = Global.Level.WOODS
			Dialogic.emit_signal("fov_0")
		elif music_name == "boss":
			Global.current_level = Global.Level.BOSS
			Dialogic.emit_signal("fov_boss")

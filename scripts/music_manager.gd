extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var current_music = "safe"

func change_music(music_name: String) -> void:
	if current_music != music_name:
		current_music = music_name
		audio_stream_player.get_stream_playback().switch_to_clip_by_name(music_name)
		if music_name == "cemetery":
			Global.current_level = Global.Level.CEMETERY

extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func change_music(music_name: String) -> void:
	audio_stream_player.get_stream_playback().switch_to_clip_by_name(music_name)

extends Area3D

@onready var musics: Node = %Musics

@export var music_name : String

func _on_area_entered(area: Area3D) -> void:
	musics.change_music(music_name)

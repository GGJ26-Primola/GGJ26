extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_3d_area_entered(area: Area3D) -> void:
	animation_player.play("open")

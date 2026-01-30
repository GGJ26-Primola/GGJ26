extends CharacterBody3D

signal attacked
#@onready var player: CharacterBody3D = %Player

func _on_hitbox_area_entered(_area: Area3D) -> void:
	print("Enemy hit")
	attacked.emit()
	queue_free()

func _on_weapon_area_entered(_area: Area3D) -> void:
	Global.player.hitted()

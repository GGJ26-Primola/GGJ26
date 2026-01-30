extends Area3D

signal attacked

func _on_area_entered(_area: Area3D) -> void:
	attacked.emit() #$"..".queue_free()

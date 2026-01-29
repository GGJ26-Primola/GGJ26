extends Area3D

signal attacked

func _on_area_entered(area: Area3D) -> void:
	attacked.emit() #$"..".queue_free()

extends CharacterBody3D

func _on_hitbox_area_entered(area: Area3D) -> void:
	print("Enemy hit")
	queue_free()

extends MeshInstance3D
var player

func _ready() -> void:
	shoot()

func shoot() -> void:
	if player != null:
		#var angle = position.signed_angle_to(player.position, Vector3.UP)
		#var rotation = create_tween()
		var tween = create_tween()
		tween.tween_property(self, "global_position", 
			player.global_position, 0.8)
		#rotation.tween_property(self, "rotation:y", angle, 0.1)
		await tween.finished
		queue_free()

extends MeshInstance3D
var player

func _ready() -> void:
	shoot()

func shoot() -> void:
	if player != null:
		#var angle = position.signed_angle_to(player.position, Vector3.UP)
	
		#var rotation = create_tween()
		
		var tween = create_tween().set_parallel(true)
		tween.tween_property(self, "global_position", 
			player.global_position, 0.8)
		#tween.tween_property(self, "rotation:y", angle, 0.8)
		await tween.finished
		queue_free()
	


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		Global.game_over = true

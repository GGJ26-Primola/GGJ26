extends Node3D

func _process(_delta: float) -> void:
	
	var player_distance = Global.player.global_position - global_position #if player != null else Vector3.ZERO
	
	if player_distance.x > 100:
		return
	
	# Limit by distance
	#player_distance.z < 10 or 
	if player_distance.length_squared() < 10.0:
		#rotation.y = 0
		return
	
	if player_distance.x < 0:
		scale = Vector3(1, 1, 1)
	else:
		scale = Vector3(-1, 1, 1)
	
	var camera_distance = Global.camera.global_position - global_position #if camera != null else Vector3.ZERO
	var direction = camera_distance.normalized()

	# Calculate angle only for Y-axis
	var angle = atan2(direction.x, direction.z)

	# Apply rotation directly or with lerp_angle for smooth turning
	rotation.y = angle 

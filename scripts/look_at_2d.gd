extends Node3D

var camera
var player

#func _on_enter_tree():
	#camera = %Camera3D
	#player = %Player

func _ready() -> void:
	camera = Global.camera
	player = Global.player

func _process(_delta: float) -> void:
	
	#if camera == null:
		#camera = get_tree().get("%Camera3D")
	#if player == null:
		#player = get_tree().get("%Player")
	
	var camera_distance = camera.global_position - global_position if camera != null else Vector3.ZERO
	var player_distance = player.global_position - global_position if player != null else Vector3.ZERO
	
	if player_distance.x < 0:
		scale = Vector3(1, 1, 1)
	else:
		scale = Vector3(-1, 1, 1)
	
	# Limit by distance
	#if distance.z < 0:
	if player_distance.length_squared() < 10.0:
		rotation.y = 0
		return
	
	var direction = camera_distance.normalized()

	# Calculate angle only for Y-axis
	var angle = atan2(direction.x, direction.z)

	# Apply rotation directly or with lerp_angle for smooth turning
	rotation.y = angle 

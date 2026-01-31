extends Node3D

@export var agro_range : float = 10.0
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var starting_point : Vector3
var is_following = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_point = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.player == null:
		return
	
	var distance : Vector3 = Global.player.global_position - starting_point
	if not is_following and distance.length_squared() < agro_range:
		is_following = true
		#TODO: Follow player
		print("follow")
	elif distance.length_squared() > agro_range:
		is_following = false
		#TODO: Return to starting point
		print("return")

extends Node3D

@export var bullet_rateo : float = 1.5
@export var idle_wait : int = 200

@onready var bullets: Node3D = $bullets
@onready var mist: FogVolume = $mist
@onready var player: CharacterBody3D = %Player

enum {IDLE, BULLETS, MIST, SCREAM, WEAK}

var State

## BULLETS STATE ##
var can_shoot := true
var bullet_current_rateo : float = 0
var bullet
var bullet_number = 0

## MIST STATE ##
var initial_mist_scale
var initial_mist_position
var can_mist := true
var expanding := true

func _ready() -> void:
	initial_mist_scale = mist.scale
	initial_mist_position = mist.position
	bullet = load("res://scenes/bullet.tscn")
	State = IDLE
	bullet_number = randi_range(1,5)
	#state_machine()
	
func sleep() -> void:
	await get_tree().create_timer(3).timeout

func _process(delta: float) -> void:
	state_machine(delta)

func fire () -> void:
	var bullet_instance = bullet.instantiate()
	#bullet_instance.position.x = player.position.x + randf_range(-1, 1)
	#bullet_instance.position.y = 1
	bullet_instance.position = Vector3(1.65,1,0)
	bullet_instance.player = player
	bullets.add_child(bullet_instance)
	
func state_machine(delta: float) -> void:
	match State:
		IDLE:
			idle_wait -= delta
			if idle_wait <= 0:
				State = MIST
		BULLETS:
			if not can_shoot:
				bullet_number = randi_range(3,7)
				can_shoot = true
				
			#print("Number of bullets: ", bullet_number)
			if can_shoot and bullet_current_rateo <= 0:
				bullet_current_rateo = bullet_rateo
				fire()
				bullet_number -= 1
				if bullet_number <= 0:
					can_shoot = false
					idle_wait = randi_range(100,200)
					State = IDLE
			else:
				bullet_current_rateo -= 0.1
		MIST:
			if can_mist:
				var tween = create_tween()
				tween.tween_property(mist, "visible", true, 1)
				await tween.finished
				can_mist = false
			elif expanding:
				expanding = false
				var expand_mist = create_tween().set_parallel(true)
				expand_mist.tween_property(mist, "scale", Vector3(5,1,8), 7)
				expand_mist.tween_property(mist, "position:z", 8, 7)
				await expand_mist.finished
				
				var remove_mist = create_tween()
				remove_mist.tween_property(mist, "scale", Vector3(0.1, 1, 0.1), 3)
				remove_mist.tween_property(mist, "global_position:z", mist.global_position.z + 15, 5)
				await remove_mist.finished
				
				var tween = create_tween()
				tween.tween_property(mist, "visible", false, 1)
				await tween.finished
				mist.position = initial_mist_position
				mist.scale = initial_mist_scale
		SCREAM:
			pass
		WEAK:
			pass

extends Node3D

@export var bullet_rateo : float = 1.5
@export var idle_wait : int = 200

@onready var bullets: Node3D = $bullets
@onready var player: CharacterBody3D = %Player
#@onready var timer: Timer = $Timer

enum {IDLE, BULLETS, MIST, SCREAM, WEAK}

var State
var can_shoot := true
var bullet_current_rateo : float = 0
var bullet
var bullet_number = 0

func _ready() -> void:
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
				State = BULLETS
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
			pass
		SCREAM:
			pass
		WEAK:
			pass

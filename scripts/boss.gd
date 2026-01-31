extends Node3D

@export var bullet_rateo : float = 1.5
@export var idle_wait : int = 200

@onready var bullets: Node3D = $bullets
@onready var mist: FogVolume = $mist
@onready var scream: Node3D = $scream
@onready var scream_mesh: MeshInstance3D = $scream/MeshInstance3D
@onready var timer: Timer = $Timer

@onready var player: CharacterBody3D = %Player
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var boss_hitbox: Area3D = $BossHitbox
var animState

enum {IDLE, BULLETS, MIST, SCREAM, PARRY, WEAK}

var State

## IDLE STATE ##
var can_idle := true

## BULLETS STATE ##
@export var can_shoot := false
var bullet_current_rateo : float = 0
var bullet
var bullet_number = 0

## MIST STATE ##
var initial_mist_scale : Vector3
var initial_mist_position : Vector3
@export var can_mist := false
var mist_expanding := false

## SCREAM STATE ##
var initial_scream_scale
var initial_scream_position
var initial_scream_height
@export var can_scream := false
var scream_expanding := false
var boss_scream
var player_scream

## PARRY STATE ##
var can_parry := true
var kill_tween := false

func _ready() -> void:
	State = IDLE
	
	bullet = load("res://scenes/bullet.tscn")
	bullet_number = randi_range(1,5)
	
	initial_mist_scale = mist.scale
	initial_mist_position = mist.position
	mist.disabled = true
	
	initial_scream_scale = scream.scale
	initial_scream_position = scream.position
	initial_scream_height = scream_mesh.mesh.height
	boss_scream = load("res://assets/2D/boss_scream.png")
	player_scream = load("res://assets/2D/player_scream.png")
	scream.hide()
	
	animState = animation_tree.get("parameters/playback")
	
#func sleep() -> void:
	#await get_tree().create_timer(3).timeout

func _process(delta: float) -> void:
	#print("can_scream: ", can_scream, "\nscream_expanding: ", scream_expanding)
	state_machine(delta)
	if Dialogic.VAR.current_mask == "pest":
		timer.stop()

func fire () -> void:
	var bullet_instance = bullet.instantiate()
	#bullet_instance.position.x = player.position.x + randf_range(-1, 1)
	#bullet_instance.position.y = 1
	bullet_instance.position = Vector3(1.3,4.3,0)
	bullet_instance.player = player
	bullets.add_child(bullet_instance)

func state_machine(delta: float) -> void:
	match State:
		IDLE:
			boss_hitbox.monitorable = false
			boss_hitbox.monitoring = false
			if can_idle:
				idle_wait -= delta
				if idle_wait <= 0:
					animState.travel("charging")
					can_idle = false
					can_mist = true
					can_scream = true
					var next_state = randf_range(0, 1)
					if next_state <= 0.8:
						State = SCREAM
					else:
						State = SCREAM

		BULLETS:
			animState.travel("bullets_in")
			if not can_shoot:
				bullet_number = randi_range(3,7)
				#can_shoot = true  # VIENE FATTO NELL'ANIMAZIONE
				#print("Number of bullets: ", bullet_number)
			if can_shoot and bullet_current_rateo <= 0:
				bullet_current_rateo = bullet_rateo
				fire()
				bullet_number -= 1
				
				if bullet_number <= 0:
					can_shoot = false
					idle_wait = randi_range(100,200)
					can_idle = true
					animState.travel("bullets_out")
					State = IDLE
			else:
				bullet_current_rateo -= 0.1
		MIST:
			animState.travel("mist")
			if can_mist:
				can_mist = false
				var tween = create_tween()
				tween.tween_property(mist, "visible", true, 1)
				await tween.finished
				mist_expanding= true
				
			elif mist_expanding:
				mist_expanding = false
				var expand_mist = create_tween().set_parallel(true)
				expand_mist.tween_property(mist, "disabled", false, 3)
				expand_mist.tween_property(mist, "scale", Vector3(5,1,8), 7)
				expand_mist.tween_property(mist, "position:z", 8, 7)
				await expand_mist.finished
				
				var remove_mist = create_tween().set_parallel(true)
				remove_mist.tween_property(mist, "global_position:z", mist.global_position.z + 15, 5)
				remove_mist.tween_property(mist, "visible", false, 5)
				
				await remove_mist.finished
				
				mist.scale = initial_mist_scale
				mist.position = initial_mist_position
				mist.disabled = true
				
				idle_wait = randi_range(100,200)
				can_idle = true
				animState.travel("idle")
				State = IDLE
		SCREAM:
			animState.travel("scream")
			if can_scream:
				#can_scream = false
				scream_expanding= true
				
				#var tween = create_tween()
				#tween.tween_property(scream, "visible", true, 1)
				#await tween.finished
				scream.show()
			
			elif scream_expanding:
				scream_expanding = false
				scream_mesh.mesh.material.uv1_offset = Vector3.ZERO
				scream_mesh.mesh.material.albedo_texture = boss_scream
				var expand_scream = create_tween().set_parallel(true)
				expand_scream.tween_property(scream, "disabled", false, 1)
				expand_scream.tween_property(scream, "scale", Vector3(20,1,20), 5)
				expand_scream.tween_property(scream_mesh, "mesh:height", 20, 5)
				expand_scream.tween_property(scream_mesh, "mesh:material:uv1_offset", Vector3(10,10,0), 5)
				await expand_scream.finished
				
				#var remove_scream = create_tween().set_parallel(true)
				##remove_scream.tween_property(scream, "scale", Vector3(0.1, 1, 0.1), 3)
				##remove_scream.tween_property(scream, "global_position:z", scream.global_position.z + 15, 5)
				#remove_scream.tween_property(scream, "disabled", true, 1)
				#remove_scream.tween_property(scream_mesh, "mesh:material:uv1_offset", Vector3(10,10,0), 1)
				#
				#await remove_scream.finished
				
				scream.hide()
				scream.disabled = true
				scream.scale = initial_scream_scale
				scream.position = initial_scream_position
				scream_mesh.mesh.height = initial_scream_height
				
				idle_wait = randi_range(100,200)
				can_idle = true
				animState.travel("idle")
				State = IDLE
		PARRY:
			if can_parry:
				can_parry = false
				animState.travel("weak")
				
				scream_mesh.mesh.material.uv1_offset = Vector3.ZERO
				scream_mesh.mesh.material.albedo_texture = player_scream
				
				var contract_scream = create_tween().set_parallel(true)
				contract_scream.tween_property(scream, "scale", Vector3(1,1,1), 1)
				contract_scream.tween_property(scream_mesh, "mesh:height", 1, 1)
				contract_scream.tween_property(scream_mesh, "mesh:material:uv1_offset", Vector3(-10,-10,0), 1)
				await contract_scream.finished
				
				scream.hide()
				scream.disabled = true
				scream.scale = initial_scream_scale
				scream.position = initial_scream_position
				scream_mesh.mesh.height = initial_scream_height
				State = WEAK
		WEAK:
			boss_hitbox.monitorable = true
			boss_hitbox.monitoring = true
			#can_idle = true
			


func _on_timer_timeout() -> void:
	Global.game_over = true


func _on_boss_hitbox_area_entered(area: Area3D) -> void:
	print("BOSS HIT")
	#boss_hitbox.monitorable = false
	#boss_hitbox.monitoring = false
	animState.travel("damage")
	animState.travel("idle")
	State = IDLE
	

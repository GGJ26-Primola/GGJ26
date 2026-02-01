extends Node3D

@export var bullet_rateo : float = 1.5
@export var idle_wait : int = 200
@onready var sprite: Sprite3D = $Sprite3D
@onready var bullets: Node3D = $bullets
@onready var mist: FogVolume = $mist
@onready var scream: Node3D = $scream
@onready var scream_mesh: MeshInstance3D = $scream/MeshInstance3D
@onready var timer: Timer = $Timer
@onready var audio_mist: AudioStreamPlayer = $"../AudioMist"
@onready var audio_bullets: AudioStreamPlayer = $"../AudioBullets"

@onready var musics: Node = $"../../Musics"

@onready var audio_idle: AudioStreamPlayer = $"../AudioIdle"
@onready var audio_death: AudioStreamPlayer = $"../AudioDeath"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var boss_hitbox: Area3D = $BossHitbox
var animState

enum {IDLE, BULLETS, MIST, SCREAM, PARRY, WEAK, DEATH}

var State
var Phase: int = 1
var move_num: int = -1

## IDLE STATE ##
var can_idle := true

## BULLETS STATE ##
@export var can_shoot := false
var bullet_current_rateo : float = 0
var bullet
var bullet_number = -1

## MIST STATE ##
var initial_mist_scale : Vector3
var initial_mist_position : Vector3
@export var can_mist := false
var mist_expanding := false
@export var mist_expand_time := 7
@export var mist_contract_time := 3


## SCREAM STATE ##
var initial_scream_scale
var initial_scream_position
var initial_scream_height
@export var can_scream := false
var scream_expanding := false
var boss_scream
var player_scream
var can_finish_scream := true
@export var scream_expand_time := 5
@export var disappear_time := 1

## PARRY STATE ##
var can_parry := true
var kill_tween := false

## WEAK STATE ##
var can_weak := false
var hit_num := 0
var max_hit := 1

## DEATH STATE ##
@export var can_die := false


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

func _process(delta: float) -> void:
	if not Global.boss_agro:
		animState.travel("idle")
		State = IDLE
		Phase = 1
		move_num = -1
		hit_num = 0
		can_idle = false
		#return
	else:
		can_idle = true
		state_machine(delta)
	if Dialogic.VAR.current_mask == "pest":
		Global.mist_damage = false
		timer.stop()

func fire () -> void:
	audio_bullets.play()
	
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = Vector3(1.3,4.3,0)
	bullets.add_child(bullet_instance)

func choose_next_move():
	scream.hide()
	scream.disabled = true
	scream.scale = initial_scream_scale
	scream.position = initial_scream_position
	scream_mesh.mesh.height = initial_scream_height
	
	
	animState.travel("charging")
	can_idle = false
	can_mist = true
	can_scream = true
	
	#var next_state = randf_range(0, 1)
	#if next_state <= 0.8:
		#State = SCREAM
	#else:
		#State = SCREAM
	
	var moves
	
	match Phase:
		1:
			moves = [BULLETS, SCREAM]
			max_hit = 1
		2:
			moves = [BULLETS, MIST, SCREAM]
			max_hit = 2
		3:
			moves = [BULLETS,MIST, BULLETS, MIST, SCREAM]
			#moves = [BULLETS, SCREAM]
			max_hit = 3
			
	move_num += 1
	if move_num > len(moves) - 1:
		move_num = -1
		Phase += 1
		if Phase > 3:
			State = DEATH
			return
		can_idle = true
		return
	State = moves[move_num]
	return

func state_machine(delta: float) -> void:
	match State:
		IDLE:
			audio_idle.play()
			if can_idle:
				idle_wait -= delta
				if idle_wait <= 0:
					choose_next_move()

		BULLETS:
			animState.travel("bullets_in")
			if not can_shoot:
				bullet_number = randi_range(3,7)
				#can_shoot = true  # VIENE FATTO NELL'ANIMAZIONE
				#print("Number of bullets: ", bullet_number)
			if can_shoot and bullet_current_rateo <= 0:
				audio_idle.stop()
				bullet_current_rateo = bullet_rateo
				fire()
				bullet_number -= 1
				
				if bullet_number <= 0:
					can_shoot = false
					idle_wait = randi_range(50, 100)
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
				audio_idle.stop()
				
				audio_mist.play()
				
				mist_expanding = false
				var expand_mist = create_tween().set_parallel(true)
				expand_mist.tween_property(mist, "disabled", false, 3)
				expand_mist.tween_property(mist, "scale", Vector3(16,1,20), mist_expand_time)
				expand_mist.tween_property(mist, "position:z", 8, mist_expand_time)
				await expand_mist.finished
				
				var remove_mist = create_tween().set_parallel(true)
				remove_mist.tween_property(mist, "global_position:z", mist.global_position.z + 15, mist_contract_time)
				remove_mist.tween_property(mist, "visible", false, mist_contract_time)
				
				await remove_mist.finished
				
				mist.scale = initial_mist_scale
				mist.position = initial_mist_position
				mist.disabled = true
				
				idle_wait = randi_range(50, 100)
				can_idle = true
				animState.travel("idle")
				State = IDLE
		SCREAM:
			animState.travel("scream")
			if can_scream:
				#can_scream = false
				scream_expanding= true
				can_finish_scream = true
				scream.show()
			
			elif scream_expanding:
				audio_idle.stop()
				
				scream_expanding = false
				scream_mesh.mesh.material.uv1_offset = Vector3.ZERO
				scream_mesh.mesh.material.albedo_texture = boss_scream
				var expand_scream = create_tween().set_parallel(true)
				expand_scream.tween_property(scream, "disabled", false, 1)
				expand_scream.tween_property(scream, "scale", Vector3(20,1,20), scream_expand_time)
				expand_scream.tween_property(scream_mesh, "mesh:height", 20, scream_expand_time)
				expand_scream.tween_property(scream_mesh, "mesh:material:uv1_offset", Vector3(10,10,0), scream_expand_time)
				await expand_scream.finished
				
				#var remove_scream = create_tween().set_parallel(true)
				##remove_scream.tween_property(scream, "scale", Vector3(0.1, 1, 0.1), 3)
				##remove_scream.tween_property(scream, "global_position:z", scream.global_position.z + 15, 5)
				#remove_scream.tween_property(scream, "disabled", true, 1)
				#remove_scream.tween_property(scream_mesh, "mesh:material:uv1_offset", Vector3(10,10,0), 1)
				#
				#await remove_scream.finished
				if can_finish_scream:
					scream.hide()
					scream.disabled = true
					scream.scale = initial_scream_scale
					scream.position = initial_scream_position
					scream_mesh.mesh.height = initial_scream_height
					
					idle_wait = randi_range(50, 100)
					can_idle = true
					animState.travel("idle")
					State = IDLE
		PARRY:
			if can_parry:
				can_parry = false
				can_finish_scream = false
				animState.travel("weak")
				
				scream_mesh.mesh.material.uv1_offset = Vector3.ZERO
				scream_mesh.mesh.material.albedo_texture = player_scream
				
				var contract_scream = create_tween().set_parallel(true)
				contract_scream.tween_property(scream, "scale", Vector3(1,1,1), disappear_time)
				contract_scream.tween_property(scream_mesh, "mesh:height", 1, disappear_time)
				contract_scream.tween_property(scream_mesh, "mesh:material:uv1_offset", Vector3(-10,-10,0), disappear_time)
				await contract_scream.finished
				
				scream.hide()
				scream.disabled = true
				#scream.scale = initial_scream_scale
				#scream.position = initial_scream_position
				#scream_mesh.mesh.height = initial_scream_height
				
				State = WEAK
		WEAK:
			boss_hitbox.monitorable = true
			boss_hitbox.monitoring = true
			scream_expanding = false
			if hit_num >= max_hit:
				can_weak = true
			else:
				#animState.travel("weak")
				can_weak = false
			if can_weak:
				boss_hitbox.monitorable = false
				boss_hitbox.monitoring = false
				hit_num = 0
				idle_wait = randi_range(50, 100)
				can_idle = true
				animState.travel("idle")
				State = IDLE
		DEATH:
			animState.travel("no_damage")
			if can_die:
				audio_idle.stop()
				audio_death.play()
				
				can_die = false
				var disappear = create_tween()
				disappear.tween_property(sprite, "modulate:a", 0, disappear_time)
				await disappear.finished
				queue_free()
				
				musics.change_music("safe")
				GameState.current_game_status = GameState.State.GAMEOVER
				Dialogic.start("gameover")

func _on_timer_timeout() -> void:
	Dialogic.VAR.boss_last_death = "mist"
	Global.mist_damage = true

	#Global.game_over = true
	Global.game_manager.game_over()

func _on_boss_hitbox_area_entered(area: Area3D) -> void:
	print("BOSS HIT")
	hit_num += 1
	animState.travel("damage")

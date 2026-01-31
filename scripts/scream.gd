extends Node3D

@onready var boss: Node3D = $".."
@onready var hitbox: Area3D = $Hitbox

var disabled: bool

func _ready() -> void:
	disabled = true

func _process(delta: float) -> void:
	#collision.disabled = disabled
	hitbox.monitoring = not disabled
	hitbox.monitorable = not disabled


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if Dialogic.VAR.current_mask != "boss":
			Dialogic.VAR.boss_last_death = "scream"
			Global.game_over = true
			#Global.game_manager.game_over()

		else:
			boss.can_parry = true
			boss.kill_tween = true
			boss.State = boss.PARRY

func _on_hitbox_body_exited(body: Node3D) -> void:
	if body.name == "Player":
			Global.game_over = false

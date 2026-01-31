extends Node3D

@onready var hitbox: Area3D = $Hitbox

var disabled: bool

func _ready() -> void:
	disabled = true

func _process(delta: float) -> void:
	#collision.disabled = disabled
	hitbox.monitoring = not disabled
	hitbox.monitorable = not disabled


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player" and Dialogic.VAR.current_mask != "boss":
			Global.game_over = true

func _on_hitbox_body_exited(body: Node3D) -> void:
	if body.name == "Player":
			Global.game_over = false

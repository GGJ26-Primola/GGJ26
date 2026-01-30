extends FogVolume

@onready var collision: CollisionShape3D = $Hitbox/CollisionShape3D
var disabled: bool

func _process(delta: float) -> void:
	collision.disabled = disabled

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player" and Dialogic.VAR.current_mask != "pest":
		Global.game_over = true

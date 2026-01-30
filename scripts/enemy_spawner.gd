extends Node3D

@export var enemy : Node3D
@export var speed : float = 1
var enemy_spawned : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_spawned == null:
		return
	
	var direction = enemy_spawned.global_position - Global.player.global_position
	direction = direction.normalized()
	enemy_spawned.global_position += direction * delta * speed

func _on_area_3d_area_entered(area: Area3D) -> void:
	if enemy_spawned == null:
		enemy_spawned = enemy.instantiate()

func _on_area_3d_area_exited(area: Area3D) -> void:
	if enemy_spawned != null:
		enemy_spawned.queue_free()

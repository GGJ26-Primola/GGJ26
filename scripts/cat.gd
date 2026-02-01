extends Node3D
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var prev_pos
var gatto_mammone := false

func _ready() -> void:
	prev_pos = global_position
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(_delta: float) -> void:
	if gatto_mammone:
		animated_sprite.play("gatto_mammone")
		position.y = 2
	elif global_position != prev_pos:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	animated_sprite.flip_h = global_position.x > prev_pos.x
	prev_pos = global_position
	
func _on_dialogic_signal(argument: String) -> void:
	if argument == "gatto_mammone":
		gatto_mammone = true

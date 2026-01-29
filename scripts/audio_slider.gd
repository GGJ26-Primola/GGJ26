extends HSlider

@export var audio_bus_name: String
var audio_bus_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	if audio_bus_id < 0:
		print("Nessun bus trovato col nome " + audio_bus_name)
		return
	value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_id))

func _on_value_changed(value_to_change: float) -> void:
	if audio_bus_id < 0:
		print("Nessun bus trovato col nome " + audio_bus_name)
		return
	var db = linear_to_db(value_to_change)
	AudioServer.set_bus_volume_db(audio_bus_id, db)

extends Control

var is_in_game: bool

func _ready() -> void:
	if get_parent().name == "root":
		is_in_game = false
	else:
		is_in_game = true
		self.visible = false
	
	%MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db((AudioServer.get_bus_index("Master"))))
	%SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db((AudioServer.get_bus_index("SFX"))))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC"):
		self.visible = not self.visible

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func linear_to_db(linear: float) -> float:
	if linear <= 0:
		return -80
	
	var l = log(linear) / log(10) # log_10 (linear)
	return 20.0 * l

func db_to_linear(db: float) -> float:
	return pow(10, db / 20.0)

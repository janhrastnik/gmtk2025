class_name ResetPressurePlate

extends PressurePlate

@export var event_name = ""

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player or parent is Rock:
		GameData.global_events.emit(event_name)

func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player or parent is Rock:
		GameData.global_events.emit(event_name)

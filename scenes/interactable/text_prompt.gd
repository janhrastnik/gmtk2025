class_name TextPrompt
extends Node2D

@export_multiline var text: String = ""

func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		GameData.prompt_events.emit(text)

func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		GameData.prompt_events.emit("")

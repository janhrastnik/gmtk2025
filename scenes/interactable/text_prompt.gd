class_name TextPrompt
extends Node2D

@export_multiline var text: String = ""
@export var one_and_done = false
@export var only_show_when_player_has_loop = false
@export var only_show_when_player_has_no_loop = false

func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		if only_show_when_player_has_loop and not parent.can_loop:
			return
		if only_show_when_player_has_no_loop and parent.can_loop:
			return
		GameData.prompt_events.emit(text)

func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		if only_show_when_player_has_loop and not parent.can_loop:
			return
		await get_tree().create_timer(3).timeout
		GameData.prompt_events.emit("")
		if one_and_done:
			call_deferred("queue_free")

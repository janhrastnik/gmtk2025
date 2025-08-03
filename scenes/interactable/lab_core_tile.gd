extends Node2D

var has_triggered := false

var victory_screen_packed = preload("res://scenes/victory_screen.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player and not has_triggered:
		parent.can_reset = false
		parent.can_loop = false
		
		has_triggered = true
		
		await get_tree().create_timer(2).timeout
		
		get_tree().change_scene_to_packed(victory_screen_packed)

extends Node2D

var has_triggered := false

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player and not has_triggered:
		parent.can_loop = true
		parent.starting_loop_position = self.global_position
		
		GameData.global_events.emit("loop_begin")
		
		parent.trigger_loop()
		has_triggered = true
		
		await get_tree().create_timer(2).timeout
		
		GameData.prompt_events.emit("Well that was weird...")

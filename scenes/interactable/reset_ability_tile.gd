extends Node2D

@onready var pickup_sound: AudioStreamPlayer = $PickupSound

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		if not parent.can_reset:
			parent.can_reset = true
			pickup_sound.play()

func _on_pickup_sound_finished() -> void:
	call_deferred("queue_free")

func _on_area_2d_area_exited(area: Area2D) -> void:
	var gate_coords = Vector2i(floor(global_position.x/12), floor(global_position.y/12)) 

	GameData.world_tilemap.set_cell(gate_coords, 1, Vector2i(9, 7), 0)

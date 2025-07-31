class_name Player
extends Node2D

var can_move_up = true
var can_move_down = true
var can_move_left = true
var can_move_right = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and can_move_up:
		position.y -= 12
	elif event.is_action_pressed("down") and can_move_down:
		position.y += 12
	elif event.is_action_pressed("left") and can_move_left:
		position.x -= 12
	elif event.is_action_pressed("right") and can_move_right:
		position.x += 12

	check_collisions()

func check_collisions():
	if GameData.world_tilemap:
		
		var pl_coords = Vector2i(floor(position.x/12), floor(position.y/12))
		
		var up = GameData.world_tilemap.get_cell_tile_data(pl_coords - Vector2i(0, 1))
		var down = GameData.world_tilemap.get_cell_tile_data(pl_coords + Vector2i(0, 1))
		var left = GameData.world_tilemap.get_cell_tile_data(pl_coords - Vector2i(1, 0))
		var right = GameData.world_tilemap.get_cell_tile_data(pl_coords + Vector2i(1, 0))

		if up is TileData:
			if up.get_custom_data("is_colliding"):
				can_move_up = false
			else:
				can_move_up = true

		if down is TileData:
			if down.get_custom_data("is_colliding"):
				can_move_down = false
			else:
				can_move_down = true

		if left is TileData:
			if left.get_custom_data("is_colliding"):
				can_move_left = false
			else:
				can_move_left = true

		if right is TileData:
			if right.get_custom_data("is_colliding"):
				can_move_right = false
			else:
				can_move_right = true

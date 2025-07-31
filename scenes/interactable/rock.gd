class_name Rock
extends Node2D

var can_move_up = true
var can_move_down = true
var can_move_left = true
var can_move_right = true

@export var level_name: String = ""

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	check_collisions()
	
	starting_position = position
	
	GameData.reset_events.connect(reset_state)
	#GameData.loop_events.connect(reset_state)

func move_rock(pl: Player):
	print("move rock call")
	if position == pl.position - Vector2(0, 12.0) and can_move_up:
		# player is below rock
		position -= Vector2(0, 12.0)
		pl.position -= Vector2(0, 12.0)
	elif position == pl.position + Vector2(0, 12.0) and can_move_down:
		position += Vector2(0, 12.0)
		pl.position += Vector2(0, 12.0)
	elif position == pl.position - Vector2(12.0, 0) and can_move_left:
		position -= Vector2(12.0, 0)
		pl.position -= Vector2(12.0, 0)
	elif position == pl.position + Vector2(12.0, 0) and can_move_right:
		position += Vector2(12.0, 0)
		pl.position += Vector2(12.0, 0)
	
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

func reset_state(level = ""):
	if level_name == level:
		position = starting_position

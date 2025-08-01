class_name Rock
extends Node2D

var can_move_up = true
var can_move_down = true
var can_move_left = true
var can_move_right = true

# references to objects player can interact with
var object_up = false
var object_down = false
var object_left = false
var object_right = false

var detect_shape = preload("res://resources/detect_shape.tres")

var object_detect_area: Area2D = Area2D.new()

var first_check = false

func _init() -> void:
	object_detect_area.position = Vector2(6.0, 6.0)
	var col_shape: CollisionShape2D = CollisionShape2D.new()
	col_shape.shape = detect_shape
	object_detect_area.add_child(col_shape)
	add_child(object_detect_area)
	
	print("init call")

func _ready() -> void:
	print("ready call")

	check_collisions()
	
func _physics_process(delta: float) -> void:
	if not first_check:
		# we need to do this in a physics frame, otherwise
		# area2d.get_overlapping_areas returns empty list
		# at the start of the game
		check_for_objects()

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

func move_rock(pl: Player):
	if position == pl.position - Vector2(0, 12.0) and can_move_up and not object_up:
		# player is below rock
		position -= Vector2(0, 12.0)
		pl.position -= Vector2(0, 12.0)
		$AudioStreamPlayer.play()
	elif position == pl.position + Vector2(0, 12.0) and can_move_down and not object_down:
		position += Vector2(0, 12.0)
		pl.position += Vector2(0, 12.0)
		$AudioStreamPlayer.play()
	elif position == pl.position - Vector2(12.0, 0) and can_move_left and not object_left:
		position -= Vector2(12.0, 0)
		pl.position -= Vector2(12.0, 0)
		$AudioStreamPlayer.play()
	elif position == pl.position + Vector2(12.0, 0) and can_move_right and not object_right:
		position += Vector2(12.0, 0)
		pl.position += Vector2(12.0, 0)
		$AudioStreamPlayer.play()
	
	check_collisions()
	check_for_objects()

func check_for_objects():
	object_up = false
	object_down = false
	object_left = false
	object_right = false
	
	print("checking")
	
	for area in object_detect_area.get_overlapping_areas():
		var parent: Node2D = area.get_parent()
		
		print("found object")
		
		if parent.position == position - Vector2(0, 12.0):
			object_up = parent
		elif parent.position == position + Vector2(0, 12.0):
			object_down = parent
		elif parent.position == position - Vector2(12.0, 0):
			object_left = parent
		elif parent.position == position + Vector2(12.0, 0):
			object_right = parent

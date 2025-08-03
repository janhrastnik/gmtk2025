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

var do_checks = false

var should_check_for_overlaps = false

func _init() -> void:
	object_detect_area.position = Vector2(6.0, 6.0)
	var col_shape: CollisionShape2D = CollisionShape2D.new()
	col_shape.shape = detect_shape
	# sadly this fucks up collisions
	# object_detect_area.set_collision_layer_value(1, false)
	object_detect_area.add_child(col_shape)
	add_child(object_detect_area)
	

func _ready() -> void:
	check_collisions()
	
func _physics_process(delta: float) -> void:
	if do_checks:
		# we need to do this in a physics frame, otherwise
		# area2d.get_overlapping_areas returns empty list
		# at the start of the game
		# print("doing checks")
		check_collisions()
		check_for_objects()
		do_checks = false
	elif should_check_for_overlaps:
		# either we just looped a loop rock and we need to check if it overlaps with a reset rock
		# or we just reseted one such reset rock, and we are checking if it overlaps with another reset rock
		
		check_for_overlaps()
		should_check_for_overlaps = false

func check_collisions():
	if GameData.world_tilemap:
		
		var pl_coords = Vector2i(floor(global_position.x/12), floor(global_position.y/12))
		
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
	if global_position == pl.global_position - Vector2(0, 12.0) and can_move_up and not object_up:
		# player is below rock
		global_position -= Vector2(0, 12.0)
		pl.global_position -= Vector2(0, 12.0)
	elif global_position == pl.global_position + Vector2(0, 12.0) and can_move_down and not object_down:
		global_position += Vector2(0, 12.0)
		pl.global_position += Vector2(0, 12.0)
	elif global_position == pl.global_position - Vector2(12.0, 0) and can_move_left and not object_left:
		global_position -= Vector2(12.0, 0)
		pl.global_position -= Vector2(12.0, 0)
	elif global_position == pl.global_position + Vector2(12.0, 0) and can_move_right and not object_right:
		global_position += Vector2(12.0, 0)
		pl.global_position += Vector2(12.0, 0)
	
	# other rocks should know of the change
	if object_up is Rock:
		object_up.do_checks = true
	if object_down is Rock:
		object_down.do_checks = true
	if object_left is Rock:
		object_left.do_checks = true
	if object_right is Rock:
		object_right.do_checks = true
	


	do_checks = true

func check_for_objects():
	# we shouldn't be finding a player here
	
	object_up = false
	object_down = false
	object_left = false
	object_right = false
	
	# print("checking")
	
	for area in object_detect_area.get_overlapping_areas():
		var parent: Node2D = area.get_parent()
		
		#print("found object")
		
		if parent.global_position == global_position - Vector2(0, 12.0):
			if parent is not Player:
				object_up = parent
			if parent is Rock:
				parent.object_down = self
		elif parent.global_position == global_position + Vector2(0, 12.0):
			if parent is not Player:	
				object_down = parent
			if parent is Rock:
				parent.object_up = self
		elif parent.global_position == global_position - Vector2(12.0, 0):
			if parent is not Player:
				object_left = parent
			if parent is Rock:
				parent.object_right = self
		elif parent.global_position == global_position + Vector2(12.0, 0):
			if parent is not Player:
				object_right = parent
			if parent is Rock:
				parent.object_left = self

func check_for_overlaps():
	# print("overlaps check")
	for area in $Area2D.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is ResetRock:
			parent.reset_state()
			parent.do_checks = true
			parent.should_check_for_overlaps = true

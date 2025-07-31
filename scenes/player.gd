class_name Player
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

@onready var object_detect_area: Area2D = $"Object Detect"
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	check_collisions()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and can_move_up:
		if object_up is Rock:
			object_up.move_rock(self)
		else:
			# normal move
			position.y -= 12
	elif event.is_action_pressed("down") and can_move_down:
		if object_down is Rock:
			object_down.move_rock(self)
		else:
			position.y += 12
	elif event.is_action_pressed("left") and can_move_left:
		sprite.flip_h = true
		
		if object_left is Rock:
			object_left.move_rock(self)
		else:
			position.x -= 12
	elif event.is_action_pressed("right") and can_move_right:
		sprite.flip_h = false
		
		if object_right is Rock:
			object_right.move_rock(self)
		else:
			position.x += 12

	check_collisions()
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

func check_for_objects():
	object_up = false
	object_down = false
	object_left = false
	object_right = false

	for area in object_detect_area.get_overlapping_areas():
		#print(position)
		var parent: Node2D = area.get_parent()
		#print(parent.position)
		if parent.position == position - Vector2(0, 12.0):
			object_up = parent
		elif parent.position == position + Vector2(0, 12.0):
			object_down = parent
		elif parent.position == position - Vector2(12.0, 0):
			object_left = parent
		elif parent.position == position + Vector2(12.0, 0):
			#print("object on the right")
			object_right = parent

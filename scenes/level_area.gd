@tool
class_name LevelArea
extends Area2D

# we hold a player reference
var player: Player = null

@export var level_shape: RectangleShape2D:
	set(new_shape):
		level_shape = new_shape
		# print("foobar")
		level_shape.changed.connect(_on_shape_changed)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var has_fetched_objects = false
var should_fetch_objects = false

# a list of references to objects
var level_objects = []

func _ready() -> void:
	if level_shape:
		collision_shape.shape = level_shape
		collision_shape.position = level_shape.size/2

func _physics_process(delta: float) -> void:
	if should_fetch_objects:
		find_level_objects()

func _on_shape_changed():
	# print("changed level shape")
	collision_shape.shape = level_shape
	collision_shape.position = level_shape.size/2

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		player = parent
		if not player.current_level:
			switch_level_area(player)
		else:
			player.next_level = self
		
		#print("AREA ENTERED")
		#print("current_level: ", player.current_level)
		#print("next_level: ", player.next_level)

func _on_area_exited(area: Area2D) -> void:
	if player:
		if player.next_level and player.current_level == self:
			player.next_level.switch_level_area(player)
		player.should_check_camera_edge_case = true

		#print("AREA EXITED")
		#print("current_level: ", player.current_level)
		#print("next_level: ", player.next_level)
				
func find_level_objects():
	# We find objects that belong to this level. We do this so that when the player
	# hits reset in a level, we know which objects to reset
	for area in get_overlapping_areas():
		var parent = area.get_parent()
		
		#print("found overlapping area")
		#print(parent)
		
		if parent is Rock:
			parent.do_checks = true
			level_objects.append(parent)
	
	has_fetched_objects = true
	should_fetch_objects = false

func reset_level_objects():
	for object in level_objects:
		# a bit fucky because this is dynamic
		# we don't exactly know what the object is and if it has reset_state() call
		
		if object is ResetRock:
			object.reset_state()

	# seperate loop because it's safer against race conditions I think
	for object in level_objects:
		if object is Rock:
			object.do_checks = true
	
	if check_for_overlapping_objects():
		# we found an overlapping object, just reset the loop rocks as well in this case
		for object in level_objects:
			if object is LoopRock:
				object.looped_state()

func check_for_overlapping_objects() -> bool:
	# check if object is on another object, this can happen with a reset rock landing on a loop rock
	for object_1 in level_objects:
		for object_2 in level_objects:
			if object_1.global_position == object_2.global_position and object_1 != object_2:
				# found a overlapping object
				return true
	return false

func switch_level_area(player: Player):
		# print("emited")
		player.current_level = self
		player.set_starting_level_position(player.position)
		GameData.camera_move_events.emit(position, level_shape.size)
		
		if player.current_level == player.next_level:
			player.next_level = null

		# we didn't really need to find objects til now
		if not has_fetched_objects:
			should_fetch_objects = true

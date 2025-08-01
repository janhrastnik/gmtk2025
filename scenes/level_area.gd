@tool
class_name LevelArea
extends Area2D

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
		# print("emited")
		parent.current_level = self
		parent.set_starting_level_position(parent.position)
		GameData.camera_move_events.emit(position, level_shape.size)
		
		# we didn't really need to find objects til now
		if not has_fetched_objects:
			should_fetch_objects = true
			
func find_level_objects():
	# We find objects that belong to this level. We do this so that when the player
	# hits reset in a level, we know which objects to reset
	for area in get_overlapping_areas():
		var parent = area.get_parent()
		
		print("found overlapping area")
		print(parent)
		
		if parent is ResetRock:
			level_objects.append(parent)
	
	has_fetched_objects = true
	should_fetch_objects = false

func reset_level_objects():
	for object in level_objects:
		# a bit fucky because this is dynamic
		# we don't exactly know what the object is and if it has reset_state() call
		object.reset_state()

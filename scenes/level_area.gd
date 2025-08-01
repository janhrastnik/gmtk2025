@tool
class_name LevelArea
extends Area2D

@export var level_shape: RectangleShape2D:
	set(new_shape):
		level_shape = new_shape
		# print("foobar")
		level_shape.changed.connect(_on_shape_changed)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape.shape = level_shape
	collision_shape.position = level_shape.size/2

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		# Code to execute in editor.
		# print("foo")
		# collision_shape.shape = level_shape
		pass

func _on_shape_changed():
	# print("changed level shape")
	collision_shape.shape = level_shape
	collision_shape.position = level_shape.size/2


func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		# print("emited")
		parent.set_starting_level_position(parent.position)
		GameData.camera_move_events.emit(position, level_shape.size)

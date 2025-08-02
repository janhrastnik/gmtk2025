class_name ResetRock
extends Rock

# @export var level_name: String = ""

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	starting_position = global_position

func reset_state():
	global_position = starting_position

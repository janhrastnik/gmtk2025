class_name ResetRock
extends Rock

# @export var level_name: String = ""

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	starting_position = position

func reset_state():
	position = starting_position

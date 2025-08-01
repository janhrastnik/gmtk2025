class_name LoopRock
extends Rock

# @export var level_name: String = ""

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	starting_position = position
	
	# GameData.reset_events.connect(reset_state)
	GameData.loop_events.connect(looped_state)

func looped_state():
	position = starting_position

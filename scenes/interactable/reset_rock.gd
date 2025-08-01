class_name ResetRock
extends Rock

@export var level_name: String = ""

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	starting_position = position
	
	GameData.reset_events.connect(reset_state)
	#GameData.loop_events.connect(reset_state)

func reset_state(level = ""):
	if level_name == level:
		position = starting_position

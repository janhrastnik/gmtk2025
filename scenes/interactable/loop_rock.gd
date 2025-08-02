class_name LoopRock
extends Rock

# @export var level_name: String = ""

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	starting_position = position
	GameData.loop_events.connect(looped_state)
	GameData.global_events.connect(looped_state_post_check)


func looped_state():
	position = starting_position
	
	# we need to check if the loop rock landed on a reset rock
	should_check_for_overlaps = true

func looped_state_post_check(event_name):
	# maybe fixes double rock push issue idk
	if event_name == "looped_state_post_check":
		do_checks = true

class_name GateOneReq
extends Node2D

@export var event_name: String = ""

var is_closed = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _init() -> void:
	# this calls before _ready i think, i hope..
	GameData.tilemap_loaded_event.connect(toggle_gate)
	GameData.global_events.connect(gate_check)
	# calling toggle_gate leads to a race condition with world_tilemap not being set
	#toggle_gate()
	
	if GameData.world_tilemap:
		# this certainly shouldn't happen, but if it does we should toggle gate
		toggle_gate()

func gate_check(received_event_name: String):
	if event_name == received_event_name:
		is_closed = not is_closed
		
		if is_closed:
			sprite.animation = "closed"
			print("Open")
		else:
			sprite.animation = "open"
			$AudioStreamPlayer.play()
			
		toggle_gate()

func toggle_gate():
	var gate_coords = Vector2i(floor(global_position.x/12), floor(global_position.y/12)) 
	
	if is_closed:
		# set the cell in the background to a wall
		GameData.world_tilemap.set_cell(gate_coords, 1, Vector2i(0, 3), 0)
	else:
		# set the cell in the background to an empty one
		GameData.world_tilemap.set_cell(gate_coords, 1, Vector2i(9, 7), 0)

	

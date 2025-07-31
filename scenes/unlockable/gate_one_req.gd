class_name GateOneReq
extends Node2D

@export var event_name: String = ""
@export var level_name: String = ""

var is_closed = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	GameData.global_events.connect(gate_check)
	# calling toggle_gate leads to a race condition with world_tilemap not being set
	# toggle_gate()

func gate_check(received_event_name: String):
	if event_name == received_event_name:
		is_closed = not is_closed
		
		if is_closed:
			sprite.animation = "closed"
		else:
			sprite.animation = "open"
		
		toggle_gate()

func toggle_gate():
	var gate_coords = Vector2i(floor(position.x/12), floor(position.y/12)) 
	
	if is_closed:
		# set the cell in the background to a wall
		GameData.world_tilemap.set_cell(gate_coords, 1, Vector2i(0, 3), 0)
	else:
		# set the cell in the background to an empty one
		GameData.world_tilemap.set_cell(gate_coords, -1, Vector2i(-1, -1), -1)

	

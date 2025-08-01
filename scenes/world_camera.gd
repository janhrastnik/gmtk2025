class_name WorldCamera
extends Node2D

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	#GameData.player_move_events.connect(adjust_camera)
	GameData.camera_move_events.connect(adjust_camera_to_level)
	pass

func adjust_camera(pl_position: Vector2):
	# 192 x 108
	var coef = floor(pl_position / Vector2(192.0, 108.0))
	camera.position = coef * Vector2(192.0, 108.0)

func adjust_camera_to_level(level_position: Vector2, level_size: Vector2):
	# size right now of viewport is 1152x648
	
	# print("camera adjust call")
	
	var x_coef = 1152/level_size.x
	var y_coef = 648/level_size.y
	
	# get_window().set_content_scale_aspect(2)
	var og_ratio = 1152/648
	var ratio = level_size.x / level_size.y
	# print(ratio)
	if ratio < og_ratio:
		get_window().set_content_scale_aspect(2)
		get_window().content_scale_size = level_size * y_coef
	else:
		get_window().set_content_scale_aspect(3)
		get_window().content_scale_size = level_size * x_coef

	# if level_size.x 
	
	# get_window().set_content_scale_mode(1)	
	# get_viewport().size = Vector2(400.0, 400.0)
	
	#get_window().content_scale_size = Vector2(400.0, 628.0)
	
	camera.position = level_position
	camera.offset = level_size/2
	#camera.zoom = Vector2(x_coef, y_coef)

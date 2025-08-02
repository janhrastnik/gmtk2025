class_name WorldCamera
extends Node2D

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	#GameData.player_move_events.connect(adjust_camera)
	GameData.world_camera = self
	GameData.camera_move_events.connect(adjust_camera_to_level)

func adjust_camera_to_level(level_position: Vector2, level_size: Vector2):
	# size right now of viewport is 1152x648
	# camera is default zoomed in on 192x108
	
	# print("camera adjust call")
	
	if not camera.enabled:
		return
	
	var x_coef = 1152/level_size.x
	var y_coef = 648/level_size.y
	
	# get_window().set_content_scale_aspect(2)
	var og_ratio = 1152.0/648.0
	var ratio = level_size.x / level_size.y
	#print(og_ratio)
	#print(ratio)
	#print(Vector2(x_coef, y_coef))
	if ratio <= og_ratio:
		#print("RATIO SMALLER")
		get_window().set_content_scale_aspect(2) # KEEP WIDTH
		get_window().content_scale_size = level_size * y_coef
	elif ratio > og_ratio:
		#print("RATIO LARGER")
		get_window().set_content_scale_aspect(3) # KEEP HEIGHT
		get_window().content_scale_size = level_size * x_coef

	if level_size.x > 192 or level_size.y > 108:
		# get_window().set_content_scale_aspect(1)
			if level_size.x/1152.0 > level_size.y/648.0:
				camera.zoom = Vector2(x_coef, x_coef)
			else:
				camera.zoom = Vector2(y_coef, y_coef)

	else:
		camera.zoom = Vector2(6, 6)
	
	#print(camera.zoom)
	
	# get_window().set_content_scale_mode(1)	
	# get_viewport().size = Vector2(400.0, 400.0)
	
	#get_window().content_scale_size = Vector2(400.0, 628.0)
	
	camera.global_position = level_position
	camera.offset = level_size/2
	#camera.zoom = Vector2(x_coef, y_coef)

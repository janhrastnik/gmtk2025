class_name Player
extends Node2D

var can_move_up = true
var can_move_down = true
var can_move_left = true
var can_move_right = true

@export var can_reset = false
@export var can_loop = false

var starting_level_position = Vector2.ZERO
@export var starting_loop_position: Vector2 = Vector2.ZERO
@export var remove_camera = false
@onready var sound_module: SoundModule = $SoundModule

# reference to the level_area the player is currently in
var current_level: LevelArea = null

# reference to the level_area that the player is entering
var next_level: LevelArea = null

# references to objects player can interact with
var object_up = null
var object_down = null
var object_left = null
var object_right = null

var should_check_camera_edge_case = false

@onready var object_detect_area: Area2D = $"Object Detect"
@onready var object_interact_area: Area2D = $"Object Interact"
@onready var sprite: Sprite2D = $Sprite2D
@onready var debug_ui: CanvasLayer = $"Debug UI"
@onready var camera: Camera2D = $Camera2D
@onready var step_timer: Timer = $"Step Timer"
@onready var vfx: VfxLayer = $VfxLayer

func _ready() -> void:
	check_collisions()
	
	# change this when switching levels
	starting_level_position = position
	
	# debug mode
	debug_ui.visible = true
	
	if remove_camera:
		camera.enabled = false
	
	GameData.loop_events.connect(loopback_player)

func _physics_process(delta: float) -> void:
	if not step_timer.time_left == 0:
		return
	elif Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
			move_event(Input.get_vector("left", "right", "up", "down"))
			
			# maybe good for performance, maybe problematic, we will see
			step_timer.start()
	if Input.is_action_pressed("up") and can_move_up:
		if object_up is Rock:
			object_up.move_rock(self)
			sound_module.play_push_sound()
		else:
			# normal move
			position.y -= 12
			sound_module.play_step_sound()
		step_timer.start()
		should_check_camera_edge_case = true
	elif Input.is_action_pressed("down") and can_move_down:
		if object_down is Rock:
			object_down.move_rock(self)
			sound_module.play_push_sound()
		else:
			position.y += 12
			sound_module.play_step_sound()
		step_timer.start()
		should_check_camera_edge_case = true
	elif Input.is_action_pressed("left") and can_move_left:
		sprite.flip_h = true
		if object_left is Rock:
			object_left.move_rock(self)
			sound_module.play_push_sound()
		else:
			position.x -= 12
			sound_module.play_step_sound()
		step_timer.start()
		should_check_camera_edge_case = true
	elif Input.is_action_pressed("right") and can_move_right:
		sprite.flip_h = false
		if object_right is Rock:
			object_right.move_rock(self)
			sound_module.play_push_sound()
		else:
			position.x += 12
			sound_module.play_step_sound()
		step_timer.start()
		should_check_camera_edge_case = true
	
	if should_check_camera_edge_case:
		camera_edge_case_check()
		should_check_camera_edge_case = false
	
func move_event(move_vector):
	check_collisions()
	check_for_objects()
	GameData.player_move_events.emit(position)
	
	sound_module.play_bonk_sound_maybe(move_vector)

func trigger_reset() -> void:
	vfx.play_reset_animation()
	# wait for the animation to do its thing
	await get_tree().create_timer(1).timeout

	reset_level()

func trigger_loop() -> void:
	vfx.play_loop_animation()
	await get_tree().create_timer(1).timeout
	
	GameData.loop_events.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset") and can_reset:
		trigger_reset()
	
	if event.is_action_pressed("loop") and can_loop:
		trigger_loop()
	
	if event.is_action_pressed("camera_toggle"):
		# print("foo")
		if camera.enabled:
			camera.enabled = false
			if GameData.world_camera:
				GameData.world_camera.camera.enabled = true
				GameData.world_camera.adjust_camera_to_level(current_level.global_position, current_level.level_shape.size)
		else:
			camera.enabled = true
			camera.zoom = Vector2(6, 6)
			get_window().content_scale_size = Vector2(1152, 648)
			if GameData.world_camera:
				GameData.world_camera.camera.enabled = false

func check_collisions():
	if GameData.world_tilemap:
		
		var pl_coords = Vector2i(floor(position.x/12), floor(position.y/12))
		
		var up = GameData.world_tilemap.get_cell_tile_data(pl_coords - Vector2i(0, 1))
		var down = GameData.world_tilemap.get_cell_tile_data(pl_coords + Vector2i(0, 1))
		var left = GameData.world_tilemap.get_cell_tile_data(pl_coords - Vector2i(1, 0))
		var right = GameData.world_tilemap.get_cell_tile_data(pl_coords + Vector2i(1, 0))

		if up is TileData:
			if up.get_custom_data("is_colliding"):
				can_move_up = false
			else:
				can_move_up = true

		if down is TileData:
			if down.get_custom_data("is_colliding"):
				can_move_down = false
			else:
				can_move_down = true

		if left is TileData:
			if left.get_custom_data("is_colliding"):
				can_move_left = false
			else:
				can_move_left = true

		if right is TileData:
			if right.get_custom_data("is_colliding"):
				can_move_right = false
			else:
				can_move_right = true

func check_for_objects():
	object_up = null
	object_down = null
	object_left = null
	object_right = null
	
	for area in object_detect_area.get_overlapping_areas():
		var parent: Node2D = area.get_parent()
		
		if parent.global_position == global_position - Vector2(0, 12.0):
			object_up = parent
		elif parent.global_position == global_position + Vector2(0, 12.0):
			object_down = parent
		elif parent.global_position == global_position - Vector2(12.0, 0):
			object_left = parent
		elif parent.global_position == global_position + Vector2(12.0, 0):
			object_right = parent

func reset_level():
	# we reset the player
	position = starting_level_position
	check_collisions()
	check_for_objects()
	
	# we reset the objects
	current_level.reset_level_objects()

func loopback_player():
	position = starting_loop_position
	check_collisions()
	check_for_objects()


func _on_step_timer_timeout() -> void:
	step_timer.stop()

func set_starting_level_position(pos: Vector2):
	starting_level_position = pos

func camera_edge_case_check():
	# if we are standing in only one level area, just switch the camera to that level area
	
	# list of references to the level areas
	var level_areas = []
	
	for area in object_interact_area.get_overlapping_areas():
		if area is LevelArea:
			level_areas.append(area)

	if len(level_areas) == 1 and current_level != level_areas[0]:
		# just switch the camera to the only level area we are in
		level_areas[0].switch_level_area(self)

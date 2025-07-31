class_name WorldCamera
extends Node2D

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	GameData.player_move_events.connect(adjust_camera)

func adjust_camera(pl_position: Vector2):
	# 192 x 108
	var coef = floor(pl_position / Vector2(192.0, 108.0))
	camera.position = coef * Vector2(192.0, 108.0)

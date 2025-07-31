class_name Player
extends Node2D

var can_move_up = false
var can_move_down = false
var can_move_left = false
var can_move_right = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		position.y -= 12
	elif event.is_action_pressed("down"):
		position.y += 12
	elif event.is_action_pressed("left"):
		position.x -= 12
	elif event.is_action_pressed("right"):
		position.x += 12

	check_collisions()

func check_collisions():
	pass

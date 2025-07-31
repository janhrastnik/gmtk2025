extends Control

func _on_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map_test.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/options.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/credits.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()

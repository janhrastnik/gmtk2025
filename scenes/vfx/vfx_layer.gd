class_name VfxLayer
extends CanvasLayer

@onready var animation_player = $AnimationPlayer

@onready var prompt_label: Label = $Text

func _ready() -> void:
	GameData.prompt_events.connect(show_text)

func play_reset_animation():
	animation_player.play("reset_animation")

func play_loop_animation():
	animation_player.play("loop_animation")

func show_text(text: String):
	var player: Player = get_parent()
	
	if text == "":
		prompt_label.visible = false
		return

	
	var player_offset = player.global_position - player.current_level.global_position 
	print(player_offset)
	prompt_label.text = text
	prompt_label.visible = true
	prompt_label.offset_left = (player_offset.x + 6.0) * GameData.world_camera.camera.zoom.x - prompt_label.size.x/2
	prompt_label.offset_top = (player_offset.y - 12.0) * GameData.world_camera.camera.zoom.y
	#prompt_label.offset = player.global_position
	#prompt_label.offset_left

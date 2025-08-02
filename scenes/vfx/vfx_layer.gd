class_name VfxLayer
extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func play_reset_animation():
	animation_player.play("reset_animation")

func play_loop_animation():
	animation_player.play("loop_animation")

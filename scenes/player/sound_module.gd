class_name SoundModule
extends Node

@onready var player: Player = get_parent()

var step_1 = preload("res://assets/sfx/steps/step1.wav")
var step_2 = preload("res://assets/sfx/steps/step2.wav")
var step_3 = preload("res://assets/sfx/steps/step3.wav")
var step_4 = preload("res://assets/sfx/steps/step4.wav")
var step_5 = preload("res://assets/sfx/steps/step5.wav")
var step_6 = preload("res://assets/sfx/steps/step6.wav")

@onready var step_sound: AudioStreamPlayer = $StepSound
@onready var bonk_sound_player: AudioStreamPlayer = $BonkSound
@onready var push_sound_player: AudioStreamPlayer = $PushSound
@onready var reset_sound_player: AudioStreamPlayer = $WarpResetSound
@onready var loop_sound_player: AudioStreamPlayer = $WarpLoopSound

var rng = RandomNumberGenerator.new()

var steps = [step_1, step_2, step_3, step_4, step_5, step_6]

var just_bonked = false

func play_step_sound():
	var random_step = rng.randi_range(0, 5)
	
	step_sound.stream = steps[random_step]
	
	var random_pitch_diff = rng.randf_range(-0.20, 0.20)
	
	step_sound.pitch_scale = 1 + random_pitch_diff
	
	step_sound.play()


func play_bonk_sound_maybe(move_vector: Vector2):
	if not player.can_move_up and move_vector == Vector2(0, -1) \
		or not player.can_move_down and move_vector == Vector2(0, 1) \
		or not player.can_move_left and move_vector == Vector2(-1, 0) \
		or not player.can_move_right and move_vector == Vector2(1, 0):
			if not just_bonked:
				bonk_sound_player.play()
				just_bonked = true
	else:
		just_bonked = false

func play_push_sound():
	push_sound_player.play()

func play_reset_sound():
	reset_sound_player.play()
	
func play_loop_sound():
	loop_sound_player.play()

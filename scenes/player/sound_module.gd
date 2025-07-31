extends Node

var step_1 = preload("res://sfx/steps/step1.wav")
var step_2 = preload("res://sfx/steps/step2.wav")
var step_3 = preload("res://sfx/steps/step3.wav")
var step_4 = preload("res://sfx/steps/step4.wav")
var step_5 = preload("res://sfx/steps/step5.wav")
var step_6 = preload("res://sfx/steps/step6.wav")

@onready var step_sound: AudioStreamPlayer = $StepSound

var rng = RandomNumberGenerator.new()

var steps = [step_1, step_2, step_3, step_4, step_5, step_6]

func play_step_sound():
	var random_step = rng.randi_range(0, 5)
	
	step_sound.stream = steps[random_step]
	
	var random_pitch_diff = rng.randf_range(-0.20, 0.20)
	
	step_sound.pitch_scale = 1 + random_pitch_diff
	
	step_sound.play()
	
	

extends AudioStreamPlayer

@onready var timer = $Timer


func play_throttle(wait_time = 0.2):
	if timer.time_left == 0.0:
		timer.start(wait_time)
		play()
	else:
		pass

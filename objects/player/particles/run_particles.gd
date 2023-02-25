extends GPUParticles3D


@onready var player: Player = get_parent()
@onready var timer: Timer = $Timer

var accelerated = false
var previous_anim = ""


func _process(delta):
	# when player starts running
	if previous_anim != "Run" and player.anims.current_animation == "Run":
		timer.start(.1)

	var should_emit = player.velocity.y == 0 and player.anims.current_animation == "Run"
	if should_emit:
		if timer.time_left <= 0:
			accelerated = true
			timer.stop()
	else:
		timer.stop()
		accelerated = false
	emitting = should_emit and accelerated
	previous_anim = player.anims.current_animation

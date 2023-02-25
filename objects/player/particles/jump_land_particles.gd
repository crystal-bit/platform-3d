extends CPUParticles3D

@onready var player: Player = get_parent()

var was_jumping = false

func _physics_process(delta):
	if player.velocity.y < 0:
		was_jumping = true
	if was_jumping and player.velocity.y == 0:
		restart() # deletes the old particle and start a new one
		was_jumping = false
	else:
		emitting = false

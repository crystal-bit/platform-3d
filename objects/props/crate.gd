class_name Crate
extends StaticBody3D

@export_range(0, 5, 1) var coins = 2


func hit():
	if coins > 0:
		$CoinSFX.play()
		$AnimationPlayer.play("hit")
		coins -= 1
		# TODO: animation

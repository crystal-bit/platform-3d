extends Node3D
class_name Coin


func _ready():
	GameState.add_coin_to_count()

func take():
	$coinGold2.hide()
	$Area3D.queue_free()
	$GPUParticles3D.emitting = true
	$GPUParticles3D.one_shot = true
	GameState.player_got_coin()
	await get_tree().create_timer(1).timeout
	queue_free()


func set_collisions_enabled(enabled: bool):
	$Area3D.monitoring = enabled
	$Area3D.monitorable = enabled

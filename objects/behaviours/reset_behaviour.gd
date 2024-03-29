extends Node

var player: Node3D

func _ready():
	player = get_parent()


func _process(delta):
	if !player:
		return
	if player.position.y < -8 or player.is_dead:
		if !$GameoverSfx.playing:
			$GameoverSfx.play()
			await get_tree().create_timer(.45).timeout
			GameState.reset_state()
			get_tree().reload_current_scene()

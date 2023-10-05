extends Node

var player: Node3D

func _ready():
	player = get_parent()


func _process(delta):
	if !player:
		return
	if player.position.y < -8:
		if !$GameoverSfx.playing:
			$GameoverSfx.play()
			await $GameoverSfx.finished
			GameState.reset_state()
			get_tree().reload_current_scene()

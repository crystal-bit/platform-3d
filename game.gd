extends Node3D

var coins = 0


func _ready():
	init_coin_events()
	init_flag_events()


func init_flag_events():
	var flag = get_tree().get_nodes_in_group("flag")[0]
	var on_level_completed = func():
		$CameraFollowTarget.animate_victory()
		$Player.victory_animation()
		await get_tree().create_timer(3).timeout
		get_tree().reload_current_scene()

	flag.level_completed.connect(on_level_completed)


func init_coin_events():
	var coin_nodes = get_tree().get_nodes_in_group("coins")
	var on_coin_collected = func():
		coins += 1

	for c in coin_nodes:
		c.collected.connect(on_coin_collected)

extends Node3D

@onready var camera: Camera3D = $CameraFocus/Camera3D
@onready var player: Player = $Player
@onready var ui = $GameplayUI


var flag: Node3D


func _ready():
	var flags = get_tree().get_nodes_in_group("flag")
	flag = flags[0]
	if flag and flag is Flag:
		flag.connect("level_complete", on_level_completed, CONNECT_ONE_SHOT)
	player.get_node("CoinArea").connect("coin_collected", _on_coin_collected)
	for crate in get_tree().get_nodes_in_group("crates"):
		if crate.has_meta("coins"):
			crate.connect("coin_collected", _on_coin_collected)


func on_level_completed():
	# position player
	$Player.set_physics_process(false)
	$Player.rotation.y = -PI/2
	$Player.position = flag.global_position + Vector3(-0.6, 0.0*$Player.HEIGHT, 0)
	$VictorySfx.play()
	# position camera
	var camera_target = Node3D.new()
	add_child(camera_target)
	camera_target.global_position = flag.global_position
	$CameraFocus.target = camera_target
	camera_target.position.y += .5
	# animate
	await get_tree().create_timer(.05).timeout
	var tween = create_tween()\
		.set_ease(Tween.EASE_OUT_IN)\
		.tween_property(camera, "fov", camera.fov - 15, 1.0)
	$VictoryScreen.appear()
	await tween.finished
	$Player.anims.play("Emote1")


func _on_victory_screen_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_coin_collected():
	var coins_label = ui.get_node("HBoxContainer/HBoxContainer/CoinsCount")
	coins_label.text = str(int(coins_label.text) + 1)

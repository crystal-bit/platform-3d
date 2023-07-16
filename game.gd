extends Node3D

var coins = 0


func _ready():
	var coin_nodes = get_tree().get_nodes_in_group("coins")
	var on_coin_collected = func():
		coins += 1
		print("coins: ", coins)

	for c in coin_nodes:
		c.collected.connect(on_coin_collected)

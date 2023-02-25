extends Area3D

signal coin_collected

func _on_area_entered(area):
	if area and area.get_parent() is Coin:
		$AudioStreamPlayer.play()
		on_coin_overlap(area.get_parent())


func on_coin_overlap(coin: Coin):
	coin.take()
	emit_signal("coin_collected")

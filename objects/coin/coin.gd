extends Area3D

signal collected


func _on_body_entered(body):
	if body is Player:
		hide()
		collected.emit()
		$CoinSFX.play()
		await $CoinSFX.finished
		queue_free()

extends Area3D

signal level_completed


func _on_body_entered(body):
	if body is Player:
		level_completed.emit()

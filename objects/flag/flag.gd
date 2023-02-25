extends Node3D
class_name Flag

signal level_complete

func _on_area_3d_body_entered(body):
	if body is Player:
		emit_signal("level_complete")

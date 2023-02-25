extends Node


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

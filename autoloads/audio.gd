extends Node


func play(node_name: String):
	print("playing", node_name)
	var audio_node = get_node(node_name) as AudioStreamPlayer
	if !audio_node:
		print_debug("Node", node_name, "not found")
	audio_node.play()

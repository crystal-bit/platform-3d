extends Node3D

@export var target: Node3D
@onready var camera: Camera3D = get_child(0)

var speed_x: float = 2.0
var speed_y: float = 0.5
var end_pos = 0.0
var end_pos_y = 0.0


func _physics_process(delta: float):
	if target and camera:
		follow_target(delta)


func follow_target(delta: float):
	var horizontal_diff = position.x - target.position.x
	var vertical_diff = position.y - target.position.y

	end_pos = target.position.x
	end_pos_y = max(-1.5, target.position.y)

	var step_x: float =  delta * speed_x
	var step_y: float = delta * speed_y
	if vertical_diff > 0: # going down
		step_y *= 5
	position.x = lerp(position.x, end_pos, step_x)
	position.y = lerp(position.y, end_pos_y, step_y)


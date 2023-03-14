extends Node3D

@onready var path_follow = $Path3D/PathFollow3D
@export var speed = 0.2

func _ready():
	pass


func _process(delta):
	if path_follow.get_progress_ratio() > 1.0 or path_follow.get_progress_ratio() < 0.0:
		speed = -speed

	path_follow.progress_ratio += speed * delta

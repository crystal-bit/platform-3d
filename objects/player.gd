extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 17.5
const DEATH_POSITION_Y = -10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var initial_position: Vector3


func _ready():
	initial_position = position
	
	
func _physics_process(delta):
	if !is_on_floor():
		if velocity.y < 0:
			velocity.y = velocity.y - gravity * 1.3 * delta
		else:
			velocity.y = velocity.y - gravity * delta
	
	if Input.is_action_pressed("player_move_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("player_move_right"):
		velocity.x = SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 5)
		
	if is_on_floor() and Input.is_action_just_pressed("player_jump"):
		velocity.y = JUMP_VELOCITY
	
	move_and_slide()
	
	if position.y < DEATH_POSITION_Y:
		position = initial_position

extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 17.5
const DEATH_POSITION_Y = -10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var initial_position: Vector3

@onready var anims = $"3DGodotRobot/AnimationPlayer"

const ROTATION_DEGREES_RIGHT = 90
const ROTATION_DEGREES_LEFT = -90


func _ready():
	initial_position = position
	rotation_degrees.y = ROTATION_DEGREES_RIGHT
	anims.play("Idle")
	anims.connect("animation_started", func(a): print("started ", a))


func _physics_process(delta):
	if !is_on_floor():
		if velocity.y < 0:
			velocity.y = velocity.y - gravity * 1.3 * delta
		else:
			velocity.y = velocity.y - gravity * delta

	if Input.is_action_pressed("player_move_left"):
		velocity.x = -SPEED
		rotation_degrees.y = ROTATION_DEGREES_LEFT
		if anims.current_animation != "Run" and is_on_floor():
			anims.play("Run")
	elif Input.is_action_pressed("player_move_right"):
		velocity.x = SPEED
		rotation_degrees.y = ROTATION_DEGREES_RIGHT
		if anims.current_animation != "Run" and is_on_floor():
			anims.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 5)
		if anims.current_animation != "Idle" and is_on_floor():
			anims.play("Idle")

	if is_on_floor() and Input.is_action_just_pressed("player_jump"):
		velocity.y = JUMP_VELOCITY
		anims.play("Jump")
		$JumpSFX.play()

	if !is_on_floor() and  velocity.y < 0:
		if anims.current_animation != "Jump":
			anims.play("Jump")

	move_and_slide()

	if position.y < DEATH_POSITION_Y:
		position = initial_position

extends CharacterBody3D
class_name Player

const SPEED = 5.0
const SLOWDOWN_SPEED = 1.5
const JUMP_VELOCITY = 14
const HEIGHT = 1.1

@export_range(1.0, 50.0, .5) var MAX_FALL_VELOCITY = 10.0
@onready var anims: AnimationPlayer = $"3DGodotRobot/AnimationPlayer"
@onready var mesh_node = $"3DGodotRobot"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 0.0

const COYOTE_FRAMES = 10
var coyote_frames: int = COYOTE_FRAMES
var jumped = false
var falling = false
var falling_and_jumped = false
var input_buffer_frames = 0
const MAX_INPUT_BUFFER_FRAMES: int = 5

var is_dead = false

func _physics_process(delta):
	var direction = _get_direction()

	handle_movement(direction, delta)
	update_animations()
	
	var prev_velocity = velocity
	var collided = move_and_slide()
	if collided:
		handle_collision(prev_velocity)

	else:
		update_layer()

func handle_movement(direction, delta):
	falling = !is_on_floor() and !jumped
	falling_and_jumped = !is_on_floor() and jumped and velocity.y <= 0
	# vertical
	if not is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			velocity.y -= 1.25 * gravity * delta
		else:
			velocity.y -= 1.75 * gravity * delta
		if velocity.y < 0:
			velocity.y = -min(abs(velocity.y), abs(MAX_FALL_VELOCITY))
			if falling:
				coyote_frames -= 1
			if falling_and_jumped:
				input_buffer_frames -= 1
	else:
		jumped = false
		coyote_frames = COYOTE_FRAMES

	var can_jump = is_on_floor() or (falling and coyote_frames > 0)
	var jump_requested = Input.is_action_just_pressed("ui_accept") or input_buffer_frames > 0
	if jump_requested and can_jump:
		velocity.y = JUMP_VELOCITY
		$Sfx/JumpSfx.play()
		jumped = true
		input_buffer_frames = 0
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor():
		input_buffer_frames = MAX_INPUT_BUFFER_FRAMES
	# horizontal
	if direction:
		speed = lerp(speed, SPEED, delta * 15.)
		velocity.x = direction.x * speed
	else:
		speed = 0.0
		velocity.x = move_toward(velocity.x, 0, SLOWDOWN_SPEED)
	# sounds
	if is_on_floor() and abs(velocity.x) > 0:
		$Sfx/RunSfx.play_throttle()


func _get_direction() -> Vector3:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


func update_layer():
	# collide with objects on layer 2 only if going down
	set_collision_mask_value(2, velocity.y <= 0)


func update_animations():
	if is_on_floor():
		if velocity == Vector3.ZERO:
			anims.play('Idle')
			return
		if abs(velocity.x) > 0:
			anims.play("Run")
		if velocity.x > 0:
			mesh_node.rotation.y = 0
		elif velocity.x < 0:
			mesh_node.rotation.y = -PI
	else:
		if velocity.y > 0:
			anims.play("Jump")


func handle_collision(prev_velocity: Vector3):
	var col = get_last_slide_collision()
	var collider = col.get_collider()
	if collider.has_meta("type"):
		if collider.get_meta("type") == "crate":
			if prev_velocity.y > 0.0:
				on_crate_hit(collider)


func on_crate_hit(crate):
	var body = $TopRay.get_collider()
	if body == crate:
		crate.hit()


func _on_bump_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("die"):
			body.die()
			velocity.y = JUMP_VELOCITY
			$Sfx/JumpSfx.play()
			$JumpLandParticles.restart()

func _on_die_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		set_physics_process(false)
		anims.play("Hurt")
		is_dead = true

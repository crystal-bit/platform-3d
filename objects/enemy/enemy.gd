extends CharacterBody3D
class_name Enemy

@onready var anim = $monster/AnimationPlayer
@onready var raycast = $RayCast3D
@onready var collision = $CollisionShape3D

const SPEED = 2.5
const FACE_ANGLE_LEFT = -90.0
const FACE_ANGLE_RIGHT = 90.0

var dead: bool = false

var direction: Vector3

var direction_array: Array[Vector3] = [
	Vector3.RIGHT, 
	Vector3.LEFT
]

func _ready() -> void:
	direction = direction_array.pick_random()
	set_face_angle(direction)
	anim.play("Walk")

func _physics_process(delta: float) -> void:
	if direction: 
		velocity.x = direction.x * SPEED
		
	if !raycast.is_colliding() and not dead:
		change_direction()

	move_and_slide()

func change_direction() -> void:
	if direction == Vector3.RIGHT:
		direction = Vector3.LEFT
		set_face_angle(direction)
	elif direction == Vector3.LEFT:
		direction = Vector3.RIGHT
		set_face_angle(direction)

func set_face_angle(current_direction: Vector3) -> void:
	if current_direction == Vector3.RIGHT:
		rotation.y = FACE_ANGLE_RIGHT
	elif current_direction == Vector3.LEFT:
		rotation.y = FACE_ANGLE_LEFT

func die() -> void:
	dead = true
	set_collision_mask_value(1, false)
	set_collision_layer_value(3, false)	
	rotation.y = 0
	direction = Vector3.ZERO
	anim.set_speed_scale(0.5)
	anim.play("Death")
	$die_sfx.play()
	set_physics_process(false)
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_die_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if not dead:
			die()

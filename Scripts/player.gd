extends CharacterBody3D

const SPEED := 5.0
const JUMP_VELOCITY := 10.0

@export var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var camera := $TwistPivot/PitchPivot/Camera3D

var normal_falling_multiplier := 2.0
var smash_falling_multiplier := 100.0
var is_smashing := false
var disable_smash_vector_y_factor := 0.25

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	#Free mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_just_pressed("smash_ground"):
			if (velocity.y > 0 && velocity.y < disable_smash_vector_y_factor * JUMP_VELOCITY) || (velocity.y < 0 && velocity.y > - disable_smash_vector_y_factor * JUMP_VELOCITY):
				velocity += get_gravity() * delta * smash_falling_multiplier
				is_smashing = true
		else:
			velocity += get_gravity() * delta * normal_falling_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var forward = camera.global_basis.z
	var right = camera.global_basis.x
	var direction = forward * input_dir.y + right * input_dir.x
	direction.y = 0.0
	direction = direction.normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#Camera movement2
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, 0.5)
	twist_input = 0.0
	pitch_input = 0.0

	move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	#Camera movement1
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
			
	#Lock mouse if it was free
	if event is InputEventMouseButton:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

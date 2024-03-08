extends CharacterBody3D

@onready var head = $Head
@onready var headBobber = $Head/HeadBobber
@onready var timer = $Timer
@onready var footstepSFX = $Footsteps

# speed vars
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0

var currentSpeed = WALK_SPEED

# other movement vars
const MOUSE_SENS = 0.4

var lerpSpeed = 10.0
var direction = Vector3.ZERO

# states
var walking = false
var sprinting = false

# head bobbing vars
const HEAD_BOB_SPRINT_SPEED = 22.0
const HEAD_BOB_WALK_SPEED = 14.0

const HEAD_BOB_SPRINT_INTENSITY = 0.2
const HEAD_BOB_WALK_INTENSITY = 0.1

var headBobVector = Vector2.ZERO
var headBobIndex = 0.0
var headBobCurrentIntensity = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# translating mouse movement to camera movement
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	# exit game
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	
	if Input.is_action_pressed("sprint"):
		currentSpeed = lerp(currentSpeed, SPRINT_SPEED, delta * lerpSpeed)
		sprinting = true
		walking = false
	else:
		currentSpeed = lerp(currentSpeed, WALK_SPEED, delta * lerpSpeed)
		walking = true
		sprinting = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# handle headbob
	if sprinting:
		headBobCurrentIntensity = HEAD_BOB_SPRINT_INTENSITY
		headBobIndex += HEAD_BOB_SPRINT_SPEED * delta

	elif walking:
		headBobCurrentIntensity = HEAD_BOB_WALK_INTENSITY
		headBobIndex += HEAD_BOB_WALK_SPEED * delta
	
	if is_on_floor() && input_dir != Vector2.ZERO:
		headBobVector.y = sin(headBobIndex)
		headBobVector.x = sin(headBobIndex / 2) * 0.5
		
		headBobber.position.y = lerp(headBobber.position.y, headBobVector.y * (headBobCurrentIntensity/ 2.0), delta * lerpSpeed)
		headBobber.position.x = lerp(headBobber.position.x, headBobVector.x * headBobCurrentIntensity, delta * lerpSpeed)
	else:
		headBobber.position.y = lerp(headBobber.position.y, 0.0, delta * lerpSpeed)
		headBobber.position.x = lerp(headBobber.position.x, 0.0, delta * lerpSpeed)
	
	# Get the input direction and handle the movement/deceleration.
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerpSpeed)
	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)
	
	# footstep sounds
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backwards") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if timer.time_left <= 0:
			if sprinting:
				footstepSFX.volume_db = randf_range(-12, -15)
			elif walking:
				footstepSFX.volume_db = randf_range(-20, -17)
			footstepSFX.pitch_scale = randf_range(0.8, 1.2)
			footstepSFX.play()
			timer.start(0.25)
	
	move_and_slide()

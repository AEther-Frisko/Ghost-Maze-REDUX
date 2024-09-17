extends CharacterBody3D

@onready var head = $Head
@onready var headBobber = $Head/HeadBobber
@onready var flashlight: SpotLight3D = %Flashlight
@onready var flashlight_sfx: AudioStreamPlayer = %FlashlightSFX
@onready var footstepTimer = $footstepTimer
@onready var footstepSFX: VaryingPitchAudioPlayer = $Footsteps
@onready var move_input_component: MoveInputComponent = $MoveInputComponent
@onready var sprint_component: SprintComponent = %SprintComponent
@onready var stamina_component: MeterRechargeComponent = %StaminaComponent
@onready var health_component: MeterRechargeComponent = %HealthComponent
@onready var states: Node = $States
@onready var stamina_recharge: StateComponent = %StaminaRecharge
@onready var health_recharge: StateComponent = %HealthRecharge
@onready var sprinting: StateComponent = %Sprinting

# other movement vars
const MOUSE_SENS: float = 0.4

# states
enum state_op {IDLE, WALKING, SPRINTING}
var state: int = state_op.IDLE

# head bobbing vars
const HEAD_BOB_SPRINT_SPEED: float = 22.0
const HEAD_BOB_WALK_SPEED: float = 14.0

const HEAD_BOB_SPRINT_INTENSITY: float = 0.2
const HEAD_BOB_WALK_INTENSITY: float = 0.1

var headBobVector: Vector2 = Vector2.ZERO
var headBobIndex: float = 0.0
var headBobCurrentIntensity: float = 0.0

@export var stamina_drain: float = 0.5

@export var move_stats: SprintMoveStats
@export var stamina_stats: MeterStats
@export var health_stats: MeterStats

func _ready():
	for s in states.get_children():
		s.disable()
	# toggle sprinting ability depending on player stamina
	stamina_stats.meter_empty.connect(func():
		sprint_component.is_sprinting = false
		move_stats.speed = move_stats.walk_speed
		sprinting.disable()
		stamina_recharge.enable()
	)
	stamina_stats.meter_full.connect(sprinting.enable)
	stamina_stats.meter_full.connect(stamina_recharge.disable)
	
	# toggle off health regen when health is full
	health_stats.meter_full.connect(health_recharge.disable)
	
	sprinting.enable()
	
	move_stats.force_pos.connect(func(new_position, new_rotation):
		global_position = new_position
		global_rotation = new_rotation
	)

func _input(event):
	# translating mouse movement to camera movement
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	# flashlight toggle
	if event.is_action_pressed("flashlight"):
		if flashlight.visible:
			flashlight.hide()
		else:
			flashlight.show()
		flashlight_sfx.play()

func _physics_process(delta: float) -> void:
	move_stats.position = global_position
	# determine player state
	if move_input_component.is_moving:
		state = state_op.WALKING
		if sprint_component.is_sprinting:
			state = state_op.SPRINTING
			stamina_recharge.disable()
			stamina_stats.value -= stamina_drain
	else:
		state = state_op.IDLE
	
	# handle stamina regen
	if not is_equal_approx(stamina_stats.value, stamina_stats.max_value) \
	and state != state_op.SPRINTING:
		stamina_recharge.enable()
	
	# handle headbob
	match state:
		state_op.SPRINTING:
			headBobCurrentIntensity = HEAD_BOB_SPRINT_INTENSITY
			headBobIndex += HEAD_BOB_SPRINT_SPEED * delta
		state_op.WALKING:
			headBobCurrentIntensity = HEAD_BOB_WALK_INTENSITY
			headBobIndex += HEAD_BOB_WALK_SPEED * delta
	if not state_op.IDLE:
		headBobVector.y = sin(headBobIndex)
		headBobVector.x = sin(headBobIndex / 2) * 0.5
			
		headBobber.position.y = lerp(headBobber.position.y, headBobVector.y * (headBobCurrentIntensity/ 2.0), delta * move_stats.lerp_speed)
		headBobber.position.x = lerp(headBobber.position.x, headBobVector.x * headBobCurrentIntensity, delta * move_stats.lerp_speed)
			
		# adding extra movement to flashlight
		flashlight.rotation.y = lerp(flashlight.rotation.y, headBobVector.y * (headBobCurrentIntensity / 3.0), delta * move_stats.lerp_speed)
		flashlight.rotation.x = lerp(flashlight.rotation.x, headBobVector.x * (headBobCurrentIntensity), delta * move_stats.lerp_speed)
	else:
		headBobber.position.y = lerp(headBobber.position.y, 0.0, delta * move_stats.lerp_speed)
		headBobber.position.x = lerp(headBobber.position.x, 0.0, delta * move_stats.lerp_speed)
		
		flashlight.rotation.y = lerp(flashlight.rotation.y, 0.0, delta * move_stats.lerp_speed)
		flashlight.rotation.x = lerp(flashlight.rotation.x, 0.0, delta * move_stats.lerp_speed)
	
	# footstep sounds
	if footstepTimer.time_left <= 0 and state != state_op.IDLE:
		match state:
			state_op.SPRINTING:
				footstepSFX.volume_db = randf_range(-2, -5)
			state_op.WALKING:
				footstepSFX.volume_db = randf_range(-10, -7)
		footstepSFX.play_with_variance()
		footstepTimer.start(0.25)

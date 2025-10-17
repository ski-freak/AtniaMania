extends CharacterBody2D

var Jump_Gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var Fall_Gravity: float =  980

# player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false

# player_movement
#const SPEED = 200.0
#const JUMP_VELOCITY = -300.0
var last_direction = Vector2.RIGHT
#var ground_acceleration: float = 34
@export_category("Movement Parameters")
#@export var player_gravity_value = 980.0
@export var Jump_Peak_Time: float = 0.33 #0.33
@export var Jump_Fall_Time: float = 0.28
@export var Jump_Height: float = 66.0
@export var Speed: float = 200.0
#@export var Jump_Distance: float = 120.0
#var Speed: float = 5.0
var Jump_Velocity: float = 5.0

# mechanics
var can_dash = true
#states
# Sets the state variables to null so they can be used later?
var current_state = null
var prev_state = null

# Buffering
var jump_buffer_frames = 5
var jump_buffer_counter = 0


# Nodes
# Collects the states from the STATES.gd script and chucks them in a variable?
@onready var STATES = $STATES
@export var Wallslide_Raycasts: Node2D


@export var TopRay_Right: Node2D
@export var TopRay_Left: Node2D
@export var TopRay_Middle: Node2D




func _ready():
	Calculate_Movement_Parameters()
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE
	
func Calculate_Movement_Parameters() -> void:
	Jump_Gravity = round((2 * Jump_Height) / pow(Jump_Peak_Time, 2))
	Fall_Gravity = round((2 * Jump_Height) / pow(Jump_Fall_Time, 2))
	Jump_Velocity = round(-(Jump_Gravity * Jump_Peak_Time))
	print("Jump_Gravity: ", Jump_Gravity, " Fall_Gravity: ",Fall_Gravity, " Jump_Velocity: ",Jump_Velocity)
#	Jump_Distance = Speed * (Jump_Peak_Time + Jump_Fall_Time)

func _physics_process(delta: float) -> void:
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name())
	move_and_slide()
func gravity(delta):
	if not is_on_floor():
		if velocity.y<0:
			velocity.y += Jump_Gravity * delta
		else:
			velocity.y += Fall_Gravity * delta
		print(velocity.y)

func get_next_to_wall():
	for raycast in Wallslide_Raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				#print ("wallslide raycast right")
				return Vector2.RIGHT

			else:
				#print ("wallslide raycast left")
				return Vector2.LEFT
	return null


# Shuffles the states around so that you are in the correct one?
func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()

# Turns the player inputs into movement of the character?
func player_input():
	# Reset
	movement_input = Vector2.ZERO

	# Keyboard / D-pad digital input
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1

	# Analog stick only?
	var left_stick = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)

	# Deadzone to prevent drift
	if left_stick.length() > 0.2:
		movement_input = left_stick

	# Normalize for consistent direction magnitude
	if movement_input != Vector2.ZERO:
		movement_input = movement_input.normalized()
		#last_direction = movement_input

	# --- Other inputs ---
	jump_input = Input.is_action_pressed("Jump")
	jump_input_actuation = Input.is_action_just_pressed("Jump")
	climb_input = Input.is_action_pressed("Climb")
	dash_input = Input.is_action_just_pressed("Dash")
	# Handle jump buffering
	if jump_input_actuation:
		jump_buffer_counter = jump_buffer_frames
	elif jump_buffer_counter > 0:
		jump_buffer_counter -= 1

func upward_corner_correction(amount: int):
	var delta = get_physics_process_delta_time()
	if velocity.y < 0 and test_move(global_transform,
	Vector2(0, velocity.y*delta)):
		# i says how far the corner is, j says whether it is right or left of player
		for i in range(1, amount*2+1):
			for j in [-1.0, 1.0]:
				if !test_move(global_transform.translated(Vector2(i*j/2, 0)),
				Vector2(0, velocity.y*delta)):
					translate(Vector2(i*j/2, 0))
					if velocity.x * j < 0: velocity.x = 0
					return

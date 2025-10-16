extends CharacterBody2D

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

# player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false

# player_movement
const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var last_direction = Vector2.RIGHT
var ground_acceleration: float = 34
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
@onready var Raycasts = $Raycasts


func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE
func _physics_process(delta: float) -> void:
	# Adds the gravity in default_move (this was written by godot).
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name())
	move_and_slide()
#	print("player velocity: " , velocity)
	#default_move(delta)
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta

func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
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

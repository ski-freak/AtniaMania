extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# (this came with NPC's godot default file but not mine) Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

# player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false

# Sets the state variables to null so they can be used later?
var current_state = null
var prev_state = null
# Collects the states from the STATES.gd script and chucks them in a variable?
@onready var STATES = $STATES


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
	#default_move(delta)
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta
		print("gravity: " , velocity)
#func default_move(delta):
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

# Shuffles the states around so that you are in the correct one?
func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()

# Turns the player inputs into movement of the character?
func player_input():
	movement_input = Vector2.ZERO
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
	
	# jumps
	if Input.is_action_pressed("Jump"):
		jump_input = true
	else:
		jump_input  = false
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
	else:
		jump_input_actuation  = false
	
	# climb
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else:
		climb_input  = false
	
	# dash
	if Input.is_action_pressed("Dash"):
		dash_input = true
	else:
		dash_input  = false
	
	
	
	
	
	

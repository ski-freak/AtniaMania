extends "state.gd"

@export var coyote_frames = 5

var can_jump = true
var coyote_counter = 0

func update(delta):
	Player.gravity(delta)
	player_air_movement()

	# Decrease coyote time each frame
	if can_jump and not Player.is_on_floor():
		coyote_counter -= 1
		if coyote_counter <= 0:
			can_jump = false

	# Change to other states
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	if Player.jump_input and can_jump and Player.jump_buffer_counter > 0:
		Player.can_dash = true
		return STATES.JUMP
	return null


func enter_state():
	print("FALL STATE")
	if Player.prev_state in [STATES.IDLE, STATES.MOVE, STATES.WALLSLIDE]:
		can_jump = true
		coyote_counter = coyote_frames
	else:
		can_jump = false

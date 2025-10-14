extends "state.gd"

@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = 0.2

var can_jump = true

func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash: # this is if true
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	if Player.jump_input_actuation and can_jump:
		return STATES.JUMP
	return null

func enter_state():
	if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE or Player.prev_state == STATES.SLIDE:
		can_jump = true
		CoyoteTimer.start(coyote_duration)
	else:
		can_jump = false

	pass

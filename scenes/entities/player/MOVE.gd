
extends "state.gd"

func update(delta):
	Player.gravity(delta) # I might need to add delta to this
	player_movement() # This works because we extend state.gd where the player_movement function lives.
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.jump_input_actuation: # this is the same as saying if == true
		return STATES.JUMP
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	return null
func enter_state():
	Player.can_dash = true

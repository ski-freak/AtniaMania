
extends "state.gd"

func update(delta):
	Player.gravity(delta) # I might need to add delta to this
	player_movement() # This works because we extend state.gd where the player_movement function lives.
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.jump_input: # this is the same as saying if == true
		return STATES.JUMP
	return null

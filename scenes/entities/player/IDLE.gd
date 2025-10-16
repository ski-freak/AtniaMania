extends "state.gd"


func update(delta):
	Player.gravity(delta)
	if Player.jump_input and Player.jump_buffer_counter > 0:
		return STATES.JUMP
	if Player.movement_input.x != 0:
		return STATES.MOVE
	if Player.velocity.y >0:
		return STATES.FALL
	if Player.dash_input and Player.can_dash: # this is if true
		return STATES.DASH
	return null
func enter_state():
	Player.can_dash = true
	Player.get_node("PlayerSprite2D").modulate = Color(1, 1, 1)

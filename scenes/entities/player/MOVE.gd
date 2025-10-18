
extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement() # This works because we extend state.gd where the player_movement function lives.
	if Player.jump_input and Player.jump_buffer_counter > 0:
		return STATES.JUMP
	if Player.slide_input and Player.slide_input_lock == false:
		return STATES.SLIDE
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	return null
func enter_state():
	print("MOVE STATE")
	Player.can_dash = true
	Player.get_node("PlayerSprite2D").modulate = Color(1, 1, 1)

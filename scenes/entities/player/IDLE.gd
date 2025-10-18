extends "state.gd"


func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.jump_input and Player.jump_buffer_counter > 0:
		return STATES.JUMP
	if Player.velocity.y >0:
		return STATES.FALL
	if Player.slide_input and Player.slide_input_lock == false:
		return STATES.SLIDE
	if Player.movement_input.x != 0:
		return STATES.MOVE
	if Player.dash_input and Player.can_dash: # this is if true
		return STATES.DASH
	return null
func enter_state():
	print("IDLE STATE")
	Player.can_dash = true
	Player.get_node("PlayerSprite2D").modulate = Color(1, 1, 1)

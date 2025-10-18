extends "state.gd"

var min_shorthop_frames = 5
var jump_frame_countdown = 0

func update(delta):
	jump_frame_countdown -= 1
	jump_gravity(delta)
	player_air_movement()
	if Player.velocity.y >0:
		return STATES.FALL
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	return null
func enter_state():
	print("JUMP STATE")
	Player.velocity.y = Player.Jump_Velocity # this reaches into the Player script and edits its y velocity
	if Player.velocity.x >0 and Player.movement_input.x > 0:
		Player.velocity.x += Player.Jump_xSpeed
	elif Player.velocity.x <0 and Player.movement_input.x < 0:
		Player.velocity.x -= Player.Jump_xSpeed	
	jump_frame_countdown = min_shorthop_frames
	print(Player.Jump_Velocity)
	
func jump_gravity(delta):
	if not Player.is_on_floor():
		if Player.velocity.y>-40 and Player.jump_input:
			Player.velocity.y += Player.Jump_Gravity * 0.5 * delta
		elif Player.velocity.y<0 and (Player.jump_input or jump_frame_countdown > 0):
			Player.velocity.y += Player.Jump_Gravity * delta
		else:
			Player.velocity.y += Player.Jump_Gravity * 3 * delta

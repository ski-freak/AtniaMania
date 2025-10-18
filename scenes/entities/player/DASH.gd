extends "state.gd"

var dash_direction = Vector2.ZERO
@export var dash_speed = 530
var dashing = false
@export var dash_end_speed = 350
@export var DashExitUpMult: float = 0.75
var dash_end_velocity = Vector2.ZERO
@export var dash_duration_frames = 15 # Determines how long the dash is
var dash_frame_counter = 0 # Used to ensure the dash lasts the correct amount of time.


func update(delta):
	# Increment frame counter, then when it reaches the final frame leave the state.
	dash_frame_counter += 1
	if dash_frame_counter >= dash_duration_frames:
		Player.velocity = dash_end_velocity
		if Player.velocity.y < 0:
			Player.velocity.y = Player.velocity.y * DashExitUpMult
		dashing = false
		if Player.is_on_floor():
			return STATES.MOVE
		else:
			return STATES.FALL
	Player.upward_corner_correction(7)
	return null
func enter_state():
	print("DASH STATE")
	Player.can_dash = false
	dashing = true
	dash_frame_counter = 0 # Reset counter each time dash starts
	if Player.movement_input != Vector2.ZERO:
		dash_direction = Player.movement_input
	else:
		dash_direction = Player.last_direction
	Player.velocity = dash_direction.normalized() * dash_speed # normalizing here may be redundant
	dash_end_velocity = dash_direction.normalized() * dash_end_speed
		# --- Set sprite color for dash ---
	Player.get_node("PlayerSprite2D").modulate = Color(1, 0.5, 0.5)
  # reddish tint for dash

func exit_state():
	dashing = false
	Player.get_node("PlayerSprite2D").modulate = Color(0.5, 1.0, 1.0)
  # back to normal

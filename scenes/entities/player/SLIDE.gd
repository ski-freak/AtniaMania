extends "state.gd"

@export var min_slide_speed = 200.0
@export var slide_speed_boost = 200.0
@export var slide_accel_duration_frames = 6 # Determines how long the slide is
#@export var slide_accel_distance = 60
@export var slide_friction = 10.0
@export var slide_cooldown_timer: Timer

var sliding = false
var slide_direction = Vector2.ZERO
var slide_frame_counter = 0 # Used to ensure the slide lasts the correct amount of time.
var slide_start_speed = 200.0
var slide_accel = slide_speed_boost / slide_accel_duration_frames

func update(delta):
	slide_frame_counter += 1
	if slide_frame_counter <= slide_accel_duration_frames:
		if slide_direction == Vector2.RIGHT:
			Player.velocity.x += slide_accel
		elif slide_direction == Vector2.LEFT:
			Player.velocity.x -= slide_accel
	else:
		# Friction
		if Player.velocity.x > 0:
			Player.velocity.x = max(Player.velocity.x - slide_friction, 0)
		elif Player.velocity.x < 0:
			Player.velocity.x = min(Player.velocity.x + slide_friction, 0)
	if Player.jump_input and Player.jump_buffer_counter > 0:
		return STATES.JUMP
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.velocity == Vector2.ZERO or not Player.slide_input:
		sliding = false
	if !sliding:
		if Player.is_on_floor():
			return STATES.MOVE
		else:
			return STATES.FALL
func enter_state():
	print("SLIDE STATE")
	print("Slide accel: ", slide_accel)
	sliding = true
	Player.slide_input_lock = true
	slide_frame_counter = 0 # Reset counter each time slide starts
	if Player.movement_input.x > 0:
		slide_direction = Vector2.RIGHT
	elif Player.movement_input.x < 0:
		slide_direction = Vector2.LEFT
	elif Player.movement_input.x == 0:
		slide_direction = Player.last_direction
	if slide_direction == Vector2.RIGHT:
		Player.velocity.x = max(min_slide_speed, Player.velocity.x)
	elif slide_direction == Vector2.LEFT:
		Player.velocity.x = min(-min_slide_speed, Player.velocity.x)
	slide_start_speed = Player.velocity.x 

		# --- Set sprite color for dash ---
	Player.get_node("PlayerSprite2D").modulate = Color(1, 0.5, 0.5)
  # reddish tint for dash

func exit_state():
	sliding = false
	Player.get_node("PlayerSprite2D").modulate = Color(0.5, 1.0, 1.0)
  # back to normal

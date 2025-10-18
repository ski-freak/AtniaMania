extends "state.gd"

#@onready var CoyoteTimer = $CoyoteTimer
#@export var coyote_duration = 0.1

#var can_jump = false

func update(delta):
	Player.gravity(delta)
	player_air_movement()
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash: # this is if true
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	#if Player.jump_input_actuation and can_jump:
		#return STATES.JUMP
	return null

func enter_state():
	print("BOUNCE STATE")
	if Player.bounce_velocity != Vector2.ZERO:
		Player.velocity = Player.bounce_velocity
		Player.bounce_velocity = Vector2.ZERO
	Player.can_dash = true

	pass

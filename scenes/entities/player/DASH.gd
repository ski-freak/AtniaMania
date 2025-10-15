extends "state.gd"

var dash_direction = Vector2.ZERO
var dash_speed = 400
var dashing = false
var dash_end_speed = 200
var dash_end_velocity = Vector2.ZERO
@export var dash_duration = 0.15 # Determines how long the dash is
@onready var DashDuration_timer = $DashDuration # we use the dash_duration as an argument for this to set the duration to what we want

func update(delta):
	if !dashing: # this means if it is = false
		return STATES.FALL
	return null
func enter_state():
	Player.can_dash = false
	dashing = true
	DashDuration_timer.start(dash_duration)
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
func _on_timer_timeout() -> void:
	Player.velocity = dash_end_velocity
	dashing = false
	pass

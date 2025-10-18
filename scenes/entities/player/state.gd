extends Node


var STATES = null
var Player = null

func enter_state():
	pass
func exit_state():
	pass
func update(delta):
	return null
func player_movement():
	if Player.movement_input.x > 0:
		# Input right, moving left - Apply both movement and friction to slow down.
		if Player.velocity.x < 0:
			Player.velocity.x = min(Player.velocity.x + Player.Ground_Friction, 0)
		# Input right, moving right above max speed - Apply friction
		elif Player.velocity.x > Player.Speed:
			Player.velocity.x = max(Player.velocity.x - Player.Ground_Friction, Player.Speed)
		# Input right, stopped or moving right below max speed - Accelerate to max speed
		else:
			Player.velocity.x = min(Player.velocity.x + Player.Ground_Accel, Player.Speed)
		Player.last_direction = Vector2.RIGHT
	elif Player.movement_input.x < 0:
		# Input left, moving right - Apply both movement and friction to slow down.n.
		if Player.velocity.x > 0:
			Player.velocity.x = max(Player.velocity.x - Player.Ground_Friction, 0)
		# Input left, moving left above max speed - Apply friction
		elif Player.velocity.x < -Player.Speed:
			Player.velocity.x = min(Player.velocity.x + Player.Ground_Friction, -Player.Speed)
		# Input left, stopped or moving left below max speed - Accelerate to max speed
		else:
			Player.velocity.x = max(Player.velocity.x - Player.Ground_Accel, -Player.Speed)
		Player.last_direction = Vector2.LEFT
	else: # These two for if there is no left/right input.
		if Player.velocity.x > 0:
			Player.velocity.x = max(Player.velocity.x - Player.Ground_Friction, 0)
		elif Player.velocity.x < 0:
			Player.velocity.x = min(Player.velocity.x + Player.Ground_Friction, 0)
	Player.upward_corner_correction(7)

# Air_Accel
# Air_Friction
# Air_Lowered_Friction

func player_air_movement():
	if Player.movement_input.x > 0:
		# Input right, moving left - Apply both movement and friction to slow down.
		if Player.velocity.x < 0:
			Player.velocity.x = min(Player.velocity.x + Player.Air_Friction + Player.Air_Accel, 0)
		# Input right, moving right above max speed - Apply friction
		elif Player.velocity.x > Player.Speed:
			Player.velocity.x = max(Player.velocity.x - Player.Air_Lowered_Friction, Player.Speed)
		# Input right, stopped or moving right below max speed - Accelerate to max speed
		else:
			Player.velocity.x = min(Player.velocity.x + Player.Air_Accel, Player.Speed)
		Player.last_direction = Vector2.RIGHT
	elif Player.movement_input.x < 0:
		# Input left, moving right - Apply both movement and friction to slow down.n.
		if Player.velocity.x > 0:
			Player.velocity.x = max(Player.velocity.x - Player.Air_Friction - Player.Air_Accel, 0)
		# Input left, moving left above max speed - Apply friction
		elif Player.velocity.x < -Player.Speed:
			Player.velocity.x = min(Player.velocity.x + Player.Air_Lowered_Friction, -Player.Speed)
		# Input left, stopped or moving left below max speed - Accelerate to max speed
		else:
			Player.velocity.x = max(Player.velocity.x - Player.Air_Accel, -Player.Speed)
		Player.last_direction = Vector2.LEFT
	else: # These two for if there is no left/right input.
		if Player.velocity.x > 0:
			Player.velocity.x = max(Player.velocity.x - Player.Air_Friction, 0)
		elif Player.velocity.x < 0:
			Player.velocity.x = min(Player.velocity.x + Player.Air_Friction, 0)
	Player.upward_corner_correction(7)

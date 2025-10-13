extends "state.gd"

@export var climb_speed = 50
@export var slide_friction = .7

func update(delta):
	slide_movement(delta)
	return null

func slide_movement(delta):
	pass
	if Player.climb_input:
		if Player.movement_input.y < 0:
			Player.velocity.y = -climb_speed
		elif Player.movement_input.y > 0:
			Player.velocity.y = climb_speed
	else:
		Player.gravity(delta)
		Player.velocity.y *= slide_friction

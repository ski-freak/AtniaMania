extends Node

@onready var IDLE = $IDLE
@onready var MOVE = $MOVE
@onready var JUMP = $JUMP
@onready var FALL = $FALL
# Not added yet
@onready var DASH = $DASH
@onready var WALLSLIDE = $WALLSLIDE
@onready var BOUNCE = $BOUNCE
#@onready var CLIMB = $CLIMB

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

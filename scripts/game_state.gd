extends Node

# Global game state variables
var player_velocity: Vector2 = Vector2.ZERO
var player_rotation: float = 0.0
var player_jump_accum : float = 0.0
var spawn_position : Vector2 = Vector2.ZERO 
var player_goal : bool = false
var frames : int = 0
var missed_frames : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

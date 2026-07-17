extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Create a transform that rotates and then translates around the player's global position
	var t = Transform2D().rotated(-GameState.player_rotation).translated(%Player.global_position)
	global_transform = global_transform * %Player.global_transform.affine_inverse() * t

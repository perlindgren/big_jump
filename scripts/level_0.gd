extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Flag1.modulate = Color(0.0, 1.0, 0.0)
	GameState.spawn_position = $Flag1.position
	

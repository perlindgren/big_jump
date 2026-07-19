extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Flag1.modulate = Color(0.0, 1.0, 0.0)
	GameState.spawn_position = $Flag1.position
	
func _process(_delta) -> void:
	# this should perhaps be a signal
	if GameState.player_goal:
		$Flag2.modulate = Color(1,1,1)
		$Flag3.modulate = Color(1,1,1)
		$Flag4.modulate = Color(1,1,1)
		
		GameState.spawn_position = $Flag1.position
		GameState.player_goal = false
		%Player.respawn()
		

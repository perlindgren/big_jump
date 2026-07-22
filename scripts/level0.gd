extends Node2D

@export var next_level_time : float = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var flag = $Flag1
	flag.modulate = Color(0.0, 1.0, 0.0)
	GameState.spawn_position = flag.position
	GameState.frames = 0
	
func _process(_delta) -> void:
	# this should perhaps be a signal
	if GameState.player_goal:
		print("recording", GameState.recording)
		GameState.player_goal = false
		print("respawn in ", next_level_time, " seconds")
		await get_tree().create_timer(next_level_time).timeout
		restart()

func restart() -> void:
	$Flag2.modulate = Color(1,1,1)
	$Flag3.modulate = Color(1,1,1)
	$Flag4.modulate = Color(1,1,1)
	
	GameState.spawn_position = $Flag1.position
	GameState.clear_recording()
	%Player.respawn()
	GameState.frames = 0

func _on_hud_restart() -> void:
	print(" --- --- on hud restart --- --- ---")
	restart()

func _on_hud_replay() -> void:
	print(" --- --- on hud replay --- --- ---")
	GameState.mode = GameState.mode_states.REPLAY
	print(" recording ", GameState.recording)
	restart()

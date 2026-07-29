extends Node2D

# Assign 'heavy_sub_tree.tscn' to this slot in the Inspector

@export var next_level_time : float = 4

@onready var player = %Player

func _ready() -> void:
	# The parent instantiates quickly because the sub-tree does not exist yet.
	var level : PackedScene = GameState.levels[GameState.current_level]
	if level:
		print("levels: launching", level)
		var level_instance = level.instantiate()
		add_child(level_instance)
		level_instance.flags[0].modulate = Color(0.0, 1.0, 0.0)
		Signals.key.connect(_on_key_pickup)
		Signals.coin.connect(_on_coin_pickup)
		Signals.restart.connect(_on_restart)
		Signals.replay.connect(_on_replay)
		restart()
	else:
		print("-- error --")
		get_tree().quit(0)

# TODO should use signal instead for game state changes
func _process(_delta) -> void:
	# this should perhaps be a signal
	if GameState.player_goal:
		print("recording", GameState.recording)
		GameState.player_goal = false
		print("respawn in ", next_level_time, " seconds")
		await get_tree().create_timer(next_level_time).timeout
		GameState.mode = GameState.mode_states.REPLAY
		#get_tree().reload_current_scene()
		restart()

func restart() -> void:
	var level_instance = get_child(0)
	
	# iterate over flags, but skip first flag that is always checked
	for index in level_instance.flags.size() -1:
		print("index ", index)
		level_instance.flags[index + 1].modulate = Color(1,1,1)
	
	GameState.spawn_position = level_instance.flags[0].position
	GameState.player_direction = level_instance.flags[0].player_direction
	GameState.clear_recording()
	GameState.frames = 0
	player.respawn()

func _on_restart() -> void:
	print("levels: on_restart")
	restart()

func _on_replay() -> void:
	print("levels: on_replay")
	GameState.mode = GameState.mode_states.REPLAY
	print("levels: recording ", GameState.recording)
	restart()
	
func _on_key_pickup(nr: int) -> void:
	print("levels: key picked up", nr)

func _on_coin_pickup(value: int) -> void:
	print("levels: coins picked up", value)

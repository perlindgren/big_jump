extends Node2D

# Assign 'heavy_sub_tree.tscn' to this slot in the Inspector

@export var next_level_time : float = 4

@onready var player = %Player

func _ready() -> void:
	# The parent instantiates quickly because the sub-tree does not exist yet.
	Signals.key.connect(_on_key_pickup)
	Signals.coin.connect(_on_coin_pickup)
	Signals.restart.connect(_on_restart)
	Signals.replay.connect(_on_replay)
	Signals.next_level.connect(_on_next_level)
	instantiate_level()

func instantiate_level():
	# The parent instantiates quickly because the sub-tree does not exist yet.
	var level: PackedScene = GameState.levels[GameState.current_level]
	if level:
		print("levels: launching", level)
		var level_instance = level.instantiate()
		add_child(level_instance)
		level_instance.flags[0].modulate = Color(0.0, 1.0, 0.0)
		
		restart()
	else:
		print("-- error --")
		get_tree().quit(0)

func restart() -> void:
	var level_instance = get_child(0)
	
	# iterate over flags, but skip first flag that is always checked
	for index in level_instance.flags.size() -1:
		print("index ", index)
		level_instance.flags[index + 1].modulate = Color(1,1,1)
	
	GameState.spawn_position = level_instance.flags[0].position
	GameState.player_direction = level_instance.flags[0].player_direction
	GameState.clear_recording() # if not in replay mode
	GameState.player_goal = true # prevent user input
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

func _on_next_level(next_level: int) -> void:
	next_level = 1
	print("levels: on_next_level ", next_level)
	GameState.player_goal = true # prevent user input
	await get_tree().create_timer(next_level_time).timeout
	GameState.mode = GameState.mode_states.REPLAY
	# remove the level instance
	get_child(0).queue_free()
	
	GameState.current_level = next_level
	instantiate_level()
	
	restart()

extends Node2D

# Assign 'heavy_sub_tree.tscn' to this slot in the Inspector

@export var next_level_time : float = 4
const flag = preload("res://scenes/flag.tscn")

@onready var player = %Player
var coin_tween : Tween
var last_coin_update : int = 0
var level_instance 

func _ready() -> void:
	# The parent instantiates quickly because the sub-tree does not exist yet.
	Signals.key.connect(_on_key_pickup)
	Signals.coin.connect(_on_coin_pickup)
	Signals.restart.connect(_on_restart)
	Signals.replay.connect(_on_replay)
	Signals.next_level.connect(_on_next_level)
	Signals.flag.connect(_on_flag)
	instantiate_level()

func _on_flag(pos: Vector2) -> void: 
	print("place flag @", pos)
	var flag_instance : Flag = flag.instantiate()
	flag_instance.play()
	flag_instance.position = pos
	flag_instance.modulate = Color(0.0, 1.0, 0.0)
	# level_instance.flags.push_back(flag_instance)
	level_instance.add_child(flag_instance)
	GameState.flags_used += 1
	GameState.spawn_position = pos
	# GameState.player_direction = flag.player_direction
	
func instantiate_level():
	print("levels: instantiate level")
	
	# free old level if existing
	var nr_children = get_child_count()
	print("levels: nr_children", nr_children)
	if nr_children == 1:
		print("levels: free old level")
		get_child(0).queue_free()
	print("levels: nr_children", get_child_count())
	
	# instantiate new level
	var new_level: PackedScene = GameState.levels[GameState.current_level]
	if new_level:
		print("levels: launching", new_level)
		level_instance = new_level.instantiate()
		add_child(level_instance)
		level_instance.flags[0].modulate = Color(0.0, 1.0, 0.0)
		print("level_instance.flags[0].position", level_instance.flags[0].position)
		restart()
	else:
		print("-- error --")
		get_tree().quit(0)

func restart() -> void:
	print("restart: nr_children", get_child_count())
	
	# iterate over flags, but skip first flag that is always checked
	for index in level_instance.flags.size() -1:
		print("index ", index)
		level_instance.flags[index + 1].modulate = Color(1,1,1)
	
	GameState.spawn_position = level_instance.flags[0].position
	GameState.player_direction = level_instance.flags[0].player_direction
	print("level_instance.flags[0].position", level_instance.flags[0].position)
	GameState.clear_recording() # if not in replay mode
	GameState.player_active = false # prevent collisions
	GameState.frames = 0
	GameState.coins = 0
	GameState.coins_display = 0
	player.respawn()

func _on_restart() -> void:
	print("levels: on_restart")
	instantiate_level()

func _on_replay() -> void:
	print("levels: on_replay")
	GameState.mode = GameState.mode_states.REPLAY
	print("levels: recording ", GameState.recording)
	instantiate_level()
	
func _on_key_pickup(nr: int) -> void:
	print("levels: key picked up", nr)

func _on_coin_pickup(value: int, node: Node2D) -> void:
	print("levels: coins picked up", value)
	
	if coin_tween:
		# ongoing coin_pickup
		print("levels: kill tween")
		coin_tween.kill()
		
	GameState.coins += value
	var tween_time : float = (GameState.coins - last_coin_update) * 0.025
	
	print("levels: from ", last_coin_update, ", to", GameState.coins, ", tween time", tween_time)
	coin_tween = create_tween()
	coin_tween.tween_method(update_coins, last_coin_update, GameState.coins, tween_time)
	
	var pickup_tween = create_tween()
	print("levels: node.position", node.position)
	
	pickup_tween.tween_property(node, "position", Vector2(800, 50), 1.0)
	pickup_tween.parallel().tween_property(node, "rotation", 2 * TAU, 1.0)
	await pickup_tween.finished
	print("levels: pickup_tween finished")
	# in case of restart the node would be freed
	if node:
		node.queue_free()

	
# Tween function to update the coin counter variable
func update_coins(value: int) -> void:
	GameState.coins_display = value
	last_coin_update = value
		
func _on_next_level(next_level: int) -> void:
	# next_level = 1
	print("levels: on_next_level ", next_level)
	player.is_live = false # prevent player input
	await get_tree().create_timer(next_level_time).timeout
	# GameState.mode = GameState.mode_states.REPLAY
	GameState.current_level = next_level
	instantiate_level()
	
	
	

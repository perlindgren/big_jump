extends Node2D

@export var next_level_time : float = 4

@onready var flag1 = $Flag1
#@onready var flag2 = $Flag2
#@onready var flag3 = $Flag3
#@onready var flag4 = $Flag4
@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flag1.modulate = Color(0.0, 1.0, 0.0)
	Signals.key.connect(_on_key)
	Signals.coin.connect(_on_coin)
	restart()
	
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
	
	#flag2.modulate = Color(1,1,1)
	#flag3.modulate = Color(1,1,1)
	#flag4.modulate = Color(1,1,1)
	#
	GameState.spawn_position = flag1.position
	GameState.player_direction = flag1.player_direction
	GameState.clear_recording()
	GameState.frames = 0
	player.respawn()

func _on_hud_restart() -> void:
	print(" --- --- on hud restart --- --- ---")
	restart()

func _on_hud_replay() -> void:
	print(" --- --- on hud replay --- --- ---")
	GameState.mode = GameState.mode_states.REPLAY
	print(" recording ", GameState.recording)
	restart()
	
func _on_key(nr: int) -> void:
	print("key picked up", nr)

func _on_coin(value: int) -> void:
	print("coins picked up", value)

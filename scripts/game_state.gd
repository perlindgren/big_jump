extends Node

# Global game state variables
@export var levels: Array[PackedScene] = [
	preload("res://scenes/level1.tscn"),
	preload("res://scenes/play_menu.tscn"),
	preload("res://scenes/level0.tscn"),
	preload("res://scenes/Cave.tscn"),
	preload("res://scenes/irisSceneLevel1.tscn"),
	preload("res://scenes/Level3.tscn"),
]

@export var current_level: int = 5 # we start from level 0

var settings_music_volume: float = 100.0
var settings_fx_volume: float = 100.0

var spawn_position: Vector2 = Vector2.ZERO
var player_direction: float = 0.0
var player_active: bool = false
var frames: int = 0
var missed_frames: int = 0
var player_position: Vector2 = Vector2.ZERO
var player_velocity: Vector2 = Vector2.ZERO

var coins: int = 0 # ground truth
var coins_display: int = 0 # used for hud display

@export var recording: Dictionary[int, int] = {}
enum mode_states {RECORD, REPLAY}
var mode: mode_states = mode_states.RECORD

func is_mode_replay() -> bool:
	return mode == mode_states.REPLAY

func clear_recording() -> void:
	if mode == mode_states.RECORD:
		recording = {}
	
func add_state(input: int) -> void:
	#print("add_state ", input)
	if recording.get(frames):
		#print("same frame, old ", recording[frames])
		recording[frames] |= input
		
	else:
		recording[frames] = input
	#print("recording frame ", frames, " data ", recording[frames])

func record_input(input: int, rec_input: bool) -> bool:
	if mode == mode_states.RECORD:
		if rec_input:
			add_state(input)
		return rec_input
	else:
		if recording.get(GameState.frames):
			# print ("event ", GameState.frames, " data", recording[GameState.frames], " input", input, "mask",  recording[GameState.frames] & input)
			return recording[GameState.frames] & input
		else:
			return false

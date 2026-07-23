extends Node

# Global game state variables

var spawn_position : Vector2 = Vector2.ZERO 
var player_goal : bool = false
var frames : int = 0
var missed_frames : int = 0

@export var recording : Dictionary[int, int] = {}
enum mode_states {RECORD, REPLAY}
var mode : mode_states = mode_states.RECORD

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
			print ("event ", GameState.frames, " data", recording[GameState.frames], " input", input, "mask",  recording[GameState.frames] & input)
			return recording[GameState.frames] & input
		else:
			return false
				

class_name AudioItem

extends Node2D

@export var audio_clip : AudioStreamPlayer2D

enum AudioState { PlayOnce, PlayLoop, Stop }

signal finished

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func change_state(audio_state: AudioState, ease_in : float) -> Signal:
	match audio_state:
		AudioState.PlayOnce: 
			print("PlayOnce")
		AudioState.PlayLoop:
			print("PlayLoop")
		AudioState.Stop:
			print("Stop")
			
	return finished

class_name AudioLooper

extends Node2D

@onready var arpeggio : AudioStreamPlayer2D = $Arpeggio
@onready var hihat : AudioStreamPlayer2D = $Hihat
@onready var kick : AudioStreamPlayer2D = $Kick
@onready var piano : AudioStreamPlayer2D = $Piano

@onready var audio_listener : AudioListener2D = $Listener


@onready var sounds : Array[AudioStreamPlayer2D] = [hihat]

#[arpeggio, hihat, kick, piano]
 
#[arpeggio, hihat, kick, piano]
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bpm : float = 105.0
	var beats : float = 4 * 4
	print(60.0 * beats/bpm)
	
	for sound : AudioStreamPlayer2D in sounds:
		print("sound, ", sound)
		var tween_vol = create_tween().tween_property(sound, "volume_db", 0.0, 1.0).from(-20.0)
		sound.play()
	
	await get_tree().create_timer(2.0).timeout
	
 	var audio_positon = AudioListener2D
	
	
	
	
	#arpeggio.finished.connect(_on_apreggio_finished)
	#hihat.finished.connect(_on_hihat_finished)
	#kick.finished.connect(_on_kick_finished)
	#
	#arpeggio.volume_db = -80
	#arpeggio.play()
	#hihat.play()
	#kick.play()
	#
	# await arpeggio.play().finished
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print("arpeggio ", arpeggio.get_playback_position())
	#print("hihat    ", arpeggio.get_playback_position())
	#print("kick     ", arpeggio.get_playback_position())
	pass

func _on_apreggio_finished() -> void:
	print("The arpeggio has finished playing!")
	#arpeggio.play(0.0)
	#hihat.play(0.0)
	#kick.play(0.0)
	#play()
	
func _on_hihat_finished() -> void:
	print("The hihats has finished playing!")
	#play()

func _on_kick_finished() -> void:
	print("The hihats has finished playing!")
	#play()

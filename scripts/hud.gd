extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	pass
	#GameState.connect("replay", on_replay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Labels/Frames.text   = str(GameState.frames)
	$Labels/Missed.text   = "Missed Frames : " + str(GameState.missed_frames)
	$Labels/Jump.text     = "Jump Accum : " + str(%Player.jump_accum)
	$Labels/Velocity.text = "Velocity   : " + str(%Player.velocity)

	if Input.is_action_just_pressed(&"restart"):
		print("hud: emit restart")
		Signals.restart.emit()

	if Input.is_action_just_pressed(&"replay"):
		print("emit replay")
		Signals.replay.emit()

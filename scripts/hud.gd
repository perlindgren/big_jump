extends CanvasLayer

class_name HUD

@onready var coin_label = $CoinCounter/CoinLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Labels/Frames.text   = str(GameState.frames)
	$Labels/Missed.text   = "Missed Frames : " + str(GameState.missed_frames)
	$Labels/Jump.text     = "Jump Accum : " + str(%Player.jump_accum)
	$Labels/Velocity.text = "Velocity   : " + str(%Player.velocity)
	coin_label.text = str(GameState.coins_display)

	if Input.is_action_just_pressed(&"restart"):
		print("hud: emit restart")
		Signals.restart.emit()

	if Input.is_action_just_pressed(&"replay"):
		print("emit replay")
		Signals.replay.emit()

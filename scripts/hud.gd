extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Labels/Jump.text     = "Jump Accum : " + str(GameState.player_jump_accum)
	$Labels/Velocity.text = "Velocity   : " + str(GameState.player_velocity)
	$Labels/Frames.text   = str(GameState.frames)

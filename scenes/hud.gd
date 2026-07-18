extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Jump.text     = "Jump Accum : " + str(GameState.player_jump_accum)
	$Velocity.text = "velocity   : " + str(GameState.player_velocity)

extends Label

func _process(_delta: float) -> void:
	text   = str(GameState.blood_donated)

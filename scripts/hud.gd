extends CanvasLayer

class_name HUD

@onready var player = "/root/main/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed(&"restart"):
		print("hud: emit restart")
		Signals.restart.emit()

	if Input.is_action_just_pressed(&"replay"):
		print("emit replay")
		Signals.replay.emit()

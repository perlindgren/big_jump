extends AnimatedSprite2D

@export var player_direction : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("flag")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class_name Flag

extends AnimatedSprite2D

@export var player_direction : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("flag: positon @", position, ", direction ", player_direction)
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
#	pass

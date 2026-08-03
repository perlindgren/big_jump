extends Sprite2D

@export var rotation_speed: float = 5.0
@export var rotation_offset: float  = 0

var local_rotation : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	local_rotation += rotation_speed * delta
	rotation = local_rotation + rotation_offset

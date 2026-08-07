extends Node2D

@onready var player = %Player
@onready var camera = $Camera
@export var zoom_speed : float = 0.02
@export var zoom_max : float = 2.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.zoom = Vector2.ONE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = player.position
	# print("position", position, ", global position", global_position )
	var zoom_scale : float = max(1.0, zoom_max - player.velocity.length() / 1000.0)
	camera.zoom += zoom_speed * (Vector2(zoom_scale, zoom_scale) - camera.zoom)
	

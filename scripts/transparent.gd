extends Node2D

@onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# print("player pos", GameState.player_position)
	sprite.material.set_shader_parameter("circle_center", GameState.player_position)
	

extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass

func _on_body_entered(_body: Node2D) -> void:
	var flag : AnimatedSprite2D = $".."
	# print("flag ", body, flag.position)
	GameState.spawn_position = flag.position
	GameState.player_direction = flag.player_direction
	flag.modulate = Color(0, 1, 0) # make green

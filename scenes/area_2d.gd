extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("area2d created")
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$"../".visible = false

func _on_body_entered(body: Node2D) -> void:
	print("body entered ", body)
	if body.name == "Player":
		$"../".visible = true
	
func _on_body_exited(body: Node2D) -> void:
	print("body exited ", body)
	$"../".visible = false

extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("area2d created")
	pass # Replace with function body.
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$"../".visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print("body entered", body)
	$"../".visible = true
	
func _on_body_exited(body: Node2D) -> void:
	print("body exited", body)
	$"../".visible = false

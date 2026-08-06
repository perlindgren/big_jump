extends Button

@export var scale_amount: float = 1.1
@export var scale_time: float = 0.15

func _ready() -> void:
	print("button ready")
	
	focus_entered.connect(_on_select)
	mouse_entered.connect(_on_select)
	button_down.connect(_on_down)
	

func _on_select() -> void:
	grab_focus()
	#print("hover")
	var t : Tween = create_tween()
	t.tween_property(self, "scale", Vector2(scale_amount, scale_amount), scale_time)
	#print("tween started")
	await t.finished
	#print("tween finished")
	var t1 : Tween = create_tween()
	t1.tween_property(self, "scale", Vector2.ONE, scale_time)
	
func _on_down() -> void:
	print("down")

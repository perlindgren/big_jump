extends Node2D


@export var start_point: Vector2 = Vector2(400, 400)
@export var end_point: Vector2 = Vector2(100, 100)
@export var arrow_color: Color = Color.WHITE
@export var arrow_thickness: float = 4.0
@export var arrow_head_size: float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()
	

func _draw() -> void:
	# 1. Draw the main shaft
	draw_line(start_point, end_point, arrow_color, arrow_thickness)
	
	#draw_polygon([Vector2(0.0,0.0), Vector2(100.0, 0), Vector2(0, 100)], [arrow_color])
	
	## 2. Calculate direction and side vectors for the arrowhead
	var direction = (end_point - start_point).normalized()
	
	#
	## 3. Calculate the three points of the arrowhead triangle
	
	var point2 = end_point - (direction * arrow_head_size) + Vector2 (-direction.y, direction.x) * arrow_head_size
	var point3 = end_point - (direction * arrow_head_size) + Vector2 (direction.y, -direction.x) * arrow_head_size 
	#
	
	## 4. Draw the filled arrowhead
	draw_polygon([end_point, point2, point3], [arrow_color])

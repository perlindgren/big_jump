extends Node2D

@onready var canvas_group: CanvasGroup = $CanvasGroup

func get_canvas_group_size(group: CanvasGroup) -> Vector2:
	var min_point := Vector2(INF, INF)
	var max_point := Vector2(-INF, -INF)
	
	for child in group.get_children():
		if child is CanvasItem:
			var local_rect: Rect2 = child.get_rect()
			var xform: Transform2D = group.get_global_transform().affine_inverse() * child.get_global_transform()
			
			## Check all 4 corners of the child's item rect
			for i in range(4):
				var local_corner = local_rect.position
				if i == 1: local_corner += Vector2(local_rect.size.x, 0)
				elif i == 2: local_corner += local_rect.size
				elif i == 3: local_corner += Vector2(0, local_rect.size.y)
				
				var transformed_corner = xform * local_corner
				min_point = min_point.min(transformed_corner)
				max_point = max_point.max(transformed_corner)
				#
	if min_point == Vector2(INF, INF):
		return Vector2.ZERO
	return max_point - min_point
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size : Vector2 = get_canvas_group_size(canvas_group)
	var aspect_ratio : float = size.x / size.y
	
	print("size ", get_canvas_group_size(canvas_group), " ar ", aspect_ratio)
	canvas_group.material.set_shader_parameter("pixel_size", aspect_ratio)
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# var param : Vector2 = canvas_group.material.get_shader_parameter("pixel_size")
	pass

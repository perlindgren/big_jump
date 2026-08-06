extends Tree



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_texture: Texture2D = preload("res://icon.svg")
	
	# Create the invisible or visible root item
	var root = create_item()
	# set_hide_root(true) # Set to true if you don't want to see the root
	button_clicked.connect(_on_tree_button_clicked)
	
	root.set_text(0, "Root Item")
	
	# Create a child item
	var level0 = create_item(root)
	level0.set_text(0, "Tutorial")
	level0.add_button(0, my_texture, 1, false, "tooltip", "description")
	
	var level1 = create_item(root)
	level1.set_text(0, "Cave")
	
	
	var level2 = create_item(root)
	level2.set_text(0, "Iris")
	level2.add_button(0, my_texture, 3, false, "", "description")
	level2.add_button(0, my_texture, 4, false, "tooltip2", "description")
	
	

func _on_tree_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	print("Button clicked on item: ", item, " with ID: ", id)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#	velocity.set_text(1, "hello")

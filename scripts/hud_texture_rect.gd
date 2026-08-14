extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.avatar_loaded.connect(_on_avatar_loaded)
	Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, Steam.getSteamID())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_avatar_loaded(_user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) -> void:
	print("avatar loaded");
	var image : Image = Image.create_from_data(avatar_size,avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
	var image_tex : ImageTexture = ImageTexture.create_from_image(image)
	texture = image_tex

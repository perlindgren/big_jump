extends CharacterBody2D

@export var jump_velocity: float = 1000.0
@export var acceleration: float = 1000.0
@export var air_acceleration: float = 200.0
@export var friction: float = 600.0
@export var air_friction: float = 1.0
@export var max_speed: float = 4000.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_released("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		if is_on_floor():
			velocity.x += direction * acceleration * delta
			# print("floor angle", get_floor_angle())
		else:
			velocity.x += direction * air_acceleration * delta
	else:
		# Apply friction if there is no input
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
		
	### Cap speed
	velocity = velocity.limit_length(max_speed)
	GameState.player_velocity = velocity
	move_and_slide()

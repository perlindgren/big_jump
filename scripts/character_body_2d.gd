extends CharacterBody2D

@export var jump_velocity: float = 1000.0
@export var acceleration: float = 1000.0
@export var air_acceleration: float = 200.0
@export var friction: float = 600.0
@export var air_friction: float = 1.0
@export var max_speed: float = 4000.0
@export var rotation_speed: float = 0.05

@export var jump_accum_increment : float = 50.0

# not visible in inspector
var jump_engaged : bool = false
var jump_accum : float = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else: # is_on_floor
		if jump_engaged:
			velocity.y = -jump_accum
			jump_engaged = false
			jump_accum = 0.0

	# Handle jump.
	if Input.is_action_just_released(&"jump"):
		jump_engaged = true
		
	if Input.is_action_pressed(&"jump") && jump_accum < jump_velocity:
		jump_accum += 50.0
		
	if Input.is_action_pressed(&"cancel_jump"):
		jump_accum = 0.0

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis(&"left",&"right")
	if direction:
		if is_on_floor():
			velocity.x += direction * acceleration * delta
		else:
			velocity.x += direction * air_acceleration * delta
	else:
		# Apply friction if there is no input
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
	# Handle rotation
	var rotate_direction : float = Input.get_axis(&"rotate_clockwise", &"rotate_counter_clockwise") 
	
	
	### Cap speed
	velocity = velocity.limit_length(max_speed)
	GameState.player_velocity = velocity
	GameState.player_rotation += rotate_direction * rotation_speed
	# clamp to angles within one rotation
	if GameState.player_rotation > TAU:
		GameState.player_rotation -= TAU
	elif GameState.player_rotation < -TAU:
		GameState.player_rotation += TAU
	
	move_and_slide()

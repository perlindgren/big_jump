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
var is_dead : bool = false
var is_live : bool = true

func _physics_process(delta: float) -> void:
	if is_live == false:
		return
		
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
		jump_engaged = false
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
	
	# Cap speed
	velocity = velocity.limit_length(max_speed)
	
	# GameState update
	GameState.player_velocity = velocity
	GameState.player_rotation += rotate_direction * rotation_speed
	# clamp to angles within one rotation
	if GameState.player_rotation > TAU:
		GameState.player_rotation -= TAU
	elif GameState.player_rotation < -TAU:
		GameState.player_rotation += TAU
	
	GameState.player_jump_accum = jump_accum
	$Sprite.modulate = Color(1.0, GameState.player_jump_accum / 1000.0, 1.0)
	move_and_slide()
	
	# check collision
	# Loop through all collisions that happened this frame
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
	
		# Check if the collider is a TileMapLayer
		if collider is TileMapLayer:
			#print("rid ", PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid()))
			# var tile_position = collider.local_to_map(collision.get_position())
			match PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid()):
				2:	# leathal obstacles
					is_dead = true
					is_live = false
					print("you died", i)
					$Sprite.modulate = Color(1.0, 0.0, 0.0, 0.1)
				4:  # object such as door
					print("goal")

func _process(_delta: float) -> void:
	if is_dead:
		is_dead = false
		#$Splat.global_position = position
		$Splat.restart()
		#$Splat.emitting = true
		print("is_dead")
		await $Splat.finished
		print("revived")
		respawn()
		# Reset Player related parameters
		is_live = true

# Reset Player related parameters
func respawn() -> void:
	print(respawn)
	position = GameState.spawn_position
	velocity = Vector2(0.0, 0.0)
	jump_accum = 0.0
	GameState.player_rotation = 0.0
	GameState.player_jump_accum = 0.0

#func _on_ready() -> void:
#	respawn()
	

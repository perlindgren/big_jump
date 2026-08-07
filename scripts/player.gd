extends CharacterBody2D

@export var jump_velocity: float = 1000.0
@export var jump_accum_increment : float = 50.0
@export var acceleration: float = 1500.0
@export var air_acceleration: float = 300.0
@export var friction: float = 600.0
@export var air_friction: float = 1.0
@export var max_speed: float = 4000.0
@export var rotation_speed: float = 0.05
@export var player_scale = 0.2
@export var max_skew : float = PI 
@export var shockwave_velocity : float = 300
@export var direction_change_speed : float = 0.075

# not visible in inspector
var jump_engaged : bool = false
var jump_accum : float = 0.0
var is_live : bool = true
var has_moved : bool = false
var is_jump_pressed : bool = false
var left : float = 0.0
var right : float = 0.0
var rot_clockwise : float = 0.0
var rot_counter_clockwise : float = 0.0
var is_respawn : bool = false
var current_direction : float = 0.0
var last_direction : float = 0.0

enum input_state {
	JUMP_JUST_PRESSED = 1, 
	JUMP_JUST_RELEASED = 2, 
	LEFT_JUST_PRESSED = 4, 
	LEFT_JUST_RELEASED = 8,
	RIGHT_JUST_PRESSED = 16,
	RIGHT_JUST_RELEASED = 32,
	ROT_CLOCKWISE_JUST_PRESSED = 64,
	ROT_CLOCKWISE_JUST_RELEASED = 128,
	ROT_COUNTER_CLOCKWISE_JUST_PRESSED = 256,
	ROT_COUNTER_CLOCKWISE_JUST_RELEASED = 512,
	CANCEL_JUMP_JUST_PRESSED = 1024,
}

# Ensure node refs to be instantiated
@onready var sprite = $Sprite
@onready var sprite_mask = $Sprite/Mask
@onready var sprite_eye = $Sprite/Eye
@onready var collision = $Collision
@onready var dust = $Dust
@onready var splat = $Splat
@onready var shockwave_effect = $"/root/Main/ShockwaveLayer/ShockwaveEffect"
# @onready var audio_listener : AudioListener2D = $AudioListener2D

# aims at a fixed 60 fps
func _physics_process(delta: float) -> void:
	if not is_live:
		# death animation
		return
		
	# Update global state
	# GameState.player_position = position
	# GameState.player_velocity = velocity
	
	# Check that we meet timing, not sure if this is entirely correct way
	if delta != 1.0/60.0:
		GameState.missed_frames += 1
	
	# Move the listingen position with the player
	# audio_listener.position = position * 1.5 # TODO scaling is not right
	# print("listener ", audio_listener.position, " ", global_position)
	
	if is_respawn:
		move_and_slide()
		if is_on_floor():
			print("-- respawn reached floor --")
			is_respawn = false
			velocity = Vector2.ZERO
			GameState.player_active = true
		else:
			# print("-- respawn in progress --")
			velocity += get_gravity() * delta	
			set_player_direction(0.0)
		return
	
	# Record/Playback input actions
	var jump_just_pressed: bool = GameState.record_input(input_state.JUMP_JUST_PRESSED, Input.is_action_just_pressed(&"jump"))
	var jump_just_released: bool = GameState.record_input(input_state.JUMP_JUST_RELEASED, Input.is_action_just_released(&"jump"))
	var left_just_pressed: bool = GameState.record_input(input_state.LEFT_JUST_PRESSED, Input.is_action_just_pressed(&"left"))
	var left_just_released: bool = GameState.record_input(input_state.LEFT_JUST_RELEASED, Input.is_action_just_released(&"left"))
	var right_just_pressed: bool = GameState.record_input(input_state.RIGHT_JUST_PRESSED, Input.is_action_just_pressed(&"right"))
	var right_just_released: bool = GameState.record_input(input_state.RIGHT_JUST_RELEASED, Input.is_action_just_released(&"right"))
	var rot_clockwise_just_pressed: bool = GameState.record_input(input_state.ROT_CLOCKWISE_JUST_PRESSED, Input.is_action_just_pressed(&"rotate_clockwise"))
	var rot_clockwise_just_released: bool = GameState.record_input(input_state.ROT_CLOCKWISE_JUST_RELEASED, Input.is_action_just_released(&"rotate_clockwise"))
	var rot_counter_clockwise_just_pressed: bool = GameState.record_input(input_state.ROT_COUNTER_CLOCKWISE_JUST_PRESSED, Input.is_action_just_pressed(&"rotate_counter_clockwise"))
	var rot_counter_clockwise_just_released: bool = GameState.record_input(input_state.ROT_COUNTER_CLOCKWISE_JUST_RELEASED, Input.is_action_just_released(&"rotate_counter_clockwise"))
	var cancel_jump_just_pressed: bool = GameState.record_input(input_state.CANCEL_JUMP_JUST_PRESSED, Input.is_action_just_pressed(&"cancel_jump"))

	# Handle re-start and replay
	if jump_just_pressed or left_just_pressed or right_just_pressed or rot_clockwise_just_pressed or rot_counter_clockwise_just_pressed:
		has_moved = true
		# print("has moved")
		
	if GameState.is_mode_replay() or has_moved:
		GameState.frames += 1
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else: # is_on_floor
		if jump_engaged:
			velocity.y = -jump_accum
			jump_engaged = false
			jump_accum = 0.0

	# Handle jump.
	if jump_just_released:
		jump_engaged = true
		is_jump_pressed = false

	if jump_just_pressed:
		is_jump_pressed = true

	if is_jump_pressed and jump_accum < jump_velocity:
		jump_accum += jump_accum_increment

	if cancel_jump_just_pressed:
		jump_engaged = false
		jump_accum = 0.0

	# Handle left/right
	if left_just_pressed:
		left = 1.0
		# print("left just pressed ", left)
	elif left_just_released:
		left = 0.0
		# print("left just released ", left)
		
	if right_just_pressed:
		right = 1.0
		# print("right just pressed ", right)
	elif right_just_released:
		right = 0.0
		# print("right just released ", right)
	
	# Get the input direction and handle the movement/deceleration.
	var direction : float = right - left
	# print("direction ", direction, "is_on_floor ", is_on_floor() )
	if direction != 0.0:
		if is_on_floor():
			velocity.x += direction * acceleration * delta
			# print("is_on_floor, direction ", direction, ", velocity.x", velocity.x)
		else:
			velocity.x += direction * air_acceleration * delta
	else:
		# Apply friction if there is no input
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO

	# Handle rotation
	if rot_clockwise_just_pressed:
		rot_clockwise = 1.0
	elif rot_clockwise_just_released:
		rot_clockwise = 0.0

	if rot_counter_clockwise_just_pressed:
		rot_counter_clockwise = 1.0
	elif rot_counter_clockwise_just_released:
		rot_counter_clockwise = 0.0
	# var rotate_direction : float = rot_clockwise - rot_counter_clockwise 
	
	# Cap speed
	velocity = velocity.limit_length(max_speed)
	
	# Face player according to velocity
	# TODO smoothing?
	if velocity.x < 0.0: # left
		last_direction = -1.0
		set_player_direction(-1.0)
	elif velocity.x > 0.0: # right
		last_direction = 1.0
		set_player_direction(1.0)
	else:
		set_player_direction(0.0)
	
	# Skew player
	if sign(velocity.x) == sign(direction):
		set_player_skew(velocity.x/max_speed)
	else:
		set_player_skew(-velocity.x/max_speed)
		
	# Compress when jumping
	set_player_compress(jump_accum/jump_velocity)
	# GameState update
	
	#GameState.player_rotation += rotate_direction * rotation_speed
	## clamp to angles within one rotation
	#if GameState.player_rotation > TAU:
		#GameState.player_rotation -= TAU
	#elif GameState.player_rotation < -TAU:
		#GameState.player_rotation += TAU
	#
	#GameState.player_jump_accum = jump_accum
	sprite.modulate = Color(1.0, jump_accum/jump_velocity, 1.0)
	sprite_mask.speed_scale = velocity.x/max_speed
	
	var old_is_on_any : bool = is_on_any()
	var old_velocity : Vector2 = velocity
	
	# simulate physics	
	move_and_slide()
	
	# Check if shockwave
	if is_on_any() and not old_is_on_any:
		if ((is_on_floor() or is_on_ceiling()) and abs(old_velocity.y) > shockwave_velocity) or (is_on_wall() and abs(old_velocity.x) > shockwave_velocity):
			trigger_shockwave()
	
	check_collision()

func trigger_shockwave() -> void:
	# TODO use @onready
	#var shockwave_layer = get_node("/root/Main/ShockwaveLayer/ShockwaveEffect")
	shockwave_effect.trigger_shockwave(position/scale)

func is_on_any() -> bool:
	return is_on_floor() or is_on_ceiling() or is_on_wall()

# Loop through all collisions that happened this frame
func check_collision() -> void:
	for i in range(get_slide_collision_count()):
		#print(" range i", i)
		var collision_i = get_slide_collision(i)
		var collider = collision_i.get_collider()
		#print("collider ", collider.name)

		# Check if the collider is a TileMapLayer
		if collider is TileMapLayer:
			#print("rid ", PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid()))
			# var tile_position = collider.local_to_map(collision.get_position())
			match PhysicsServer2D.body_get_collision_layer(collision_i.get_collider_rid()):
				2:	# TileMap leathal obstacles
					is_live = false
					print("you died", i)
					sprite.modulate = Color(1.0, 1.0, 1.0, 0.2)
					splat.restart()
					print("is_dead")
					await splat.finished
					print("revived")
					respawn()
					break # make soure we do not process any other collider in this frame
				4:  # TileMap objects such as doors
					is_live = false
					print("goal")
					GameState.player_goal = true
					break

# Reset Player related parameters
func respawn() -> void:
	print("Player respawn")
	sprite.modulate = Color(1.0, 0.5, 0.5, 1.0)
	position.x = GameState.spawn_position.x
	position.y = GameState.spawn_position.y - 90
	
	velocity = Vector2.ZERO
	rotation = 0.0
	jump_accum = 0.0
	
	is_live = true
	has_moved = false
	is_jump_pressed = false
	left = 0.0
	right = 0.0 
	rot_clockwise = 0.0
	rot_counter_clockwise = 0.0
	is_respawn = true
	current_direction = 0.0
	last_direction = GameState.player_direction
	set_player_direction(GameState.player_direction)
	set_player_compress(0)
	set_player_skew(0)
	trigger_shockwave()
	

func set_player_compress(compress: float) -> void:
	if is_jump_pressed:
		var compress_scale = player_scale * (1.0 - 0.5 * compress)
		sprite.scale.y = compress_scale
		collision.scale.y = compress_scale
	else:
		sprite.scale.y = player_scale
		collision.scale.y = player_scale
		

func set_player_skew(player_skew: float) -> void:
	sprite.skew = max_skew * player_skew
	collision.skew = max_skew * player_skew
	
func set_player_direction(direction: float) -> void:
	current_direction = clamp(current_direction + last_direction * direction_change_speed, -1.0, 1.0)
	var x = abs(current_direction)
	# ease curve, smoothstep 3x²-2x³ 
	# var scaled_direction = sign(current_direction) * player_scale * (x ** 2) * (3.0 - 2.0 * x) 
	# ease curve, smootherstep  
	var scaled_direction = sign(current_direction) * player_scale * x * x * x * (x * (6.0 * x - 15.0) + 10.0)
	sprite.scale.x = scaled_direction
	collision.scale.x = scaled_direction
	dust.scale.x = direction * 0.25
	if abs(velocity.x) > 10 and is_on_floor():
		dust.emitting = true
		# Scale particle speed/lifetime with movement speed
		dust.speed_scale = remap(abs(velocity.x), 0, 1000, 0.5, 3.0)
	else:
		dust.emitting = false

func _ready() -> void:
	sprite_mask.play(&"mask_anim")
	sprite_eye.play(&"eye_anim")
	# audio_listener.make_current()
	

extends CharacterBody2D

@export var jump_velocity: float = 1000.0
@export var acceleration: float = 1500.0
@export var air_acceleration: float = 300.0
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
var has_moved : bool = false
var is_jump_pressed : bool = false

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
	ROT_COUNTER_CLOCKWISE_JUST_RELEASED = 512
}

@export var recording : Dictionary[int, int] = {}
enum mode_states {RECORD, REPLAY}
var mode : mode_states = mode_states.RECORD

func clear_recording() -> void:
	recording = {}
	
func add_state(input: int) -> void:
	print("add_state ", input)
	var frame : int = GameState.frames
	if recording.get(frame):
		print("same frame, old ", recording[frame])
		recording[frame] |= input
		
	else:
		recording[frame] = input
	print("recording frame ", frame, " data ", recording[frame])

func record_input(input: int, rec_input: bool) -> bool:
	if mode == mode_states.RECORD:
		if rec_input:
			add_state(input)
		return rec_input
	else:
		if recording.get(GameState.frames):
			return recording[GameState.frames] && input
		else:
			return false
	
func _physics_process(delta: float) -> void:
	# Check that we meet timing, not sure if this is entirely correct way
	if delta != 1.0/60.0:
		GameState.missed_frames += 1
		
	if is_live == false:
		return
	
	# Record/Playback input actions
	var jump_just_pressed: bool = record_input(input_state.JUMP_JUST_PRESSED, Input.is_action_just_pressed(&"jump"))
	
	var jump_just_released: bool = record_input(input_state.JUMP_JUST_RELEASED, Input.is_action_just_released(&"jump"))
	
	var left_just_pressed: bool = record_input(input_state.LEFT_JUST_PRESSED, Input.is_action_just_pressed(&"left"))
	
	var left_just_released: bool = record_input(input_state.LEFT_JUST_RELEASED, Input.is_action_just_released(&"left"))
	
	var right_just_pressed: bool = record_input(input_state.RIGHT_JUST_PRESSED, Input.is_action_just_pressed(&"right"))
	
	var right_just_released: bool = record_input(input_state.RIGHT_JUST_RELEASED, Input.is_action_just_released(&"right"))
	
	var rot_clockwise_just_pressed: bool = record_input(input_state.ROT_CLOCKWISE_JUST_PRESSED, Input.is_action_just_pressed(&"rotate_clockwise"))
	
	var rot_clockwise_just_released: bool = record_input(input_state.ROT_CLOCKWISE_JUST_RELEASED, Input.is_action_just_released(&"rotate_clockwise"))
	
	var rot_counter_clockwise_just_pressed: bool = record_input(input_state.ROT_COUNTER_CLOCKWISE_JUST_PRESSED, Input.is_action_just_pressed(&"rotate_counter_clockwise"))
	
	var rot_counter_clockwise_just_released: bool = record_input(input_state.ROT_COUNTER_CLOCKWISE_JUST_RELEASED, Input.is_action_just_released(&"rotate_counter_clockwise"))
		
	if jump_just_pressed or left_just_pressed or right_just_pressed or rot_clockwise_just_pressed or rot_counter_clockwise_just_pressed:
		has_moved = true
		
	if has_moved:
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
	$Sprite.modulate = Color(1.0, GameState.player_jump_accum /jump_velocity, 1.0)
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
					is_live = false
					print("goal")
					GameState.player_goal = true

func _process(_delta: float) -> void:
	if is_dead:
		is_dead = false
		$Splat.restart()
		#print("is_dead")
		await $Splat.finished
		#print("revived")
		respawn()

# Reset Player related parameters
func respawn() -> void:
	print("Player respawn")
	position = GameState.spawn_position
	velocity = Vector2.ZERO
	jump_accum = 0.0
	GameState.player_rotation = 0.0
	GameState.player_jump_accum = 0.0
	is_live = true
	has_moved = false 

#func _on_ready() -> void:
#	respawn()
	

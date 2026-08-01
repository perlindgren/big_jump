class_name Portal

extends Sprite2D

enum State { UNLOCKED, LOCKED, LOCKED2, BARS, BARS2 }

@export var portal_id : int = 0
@export var state : State = State.LOCKED
@export var active : bool = false 

@onready var bars = $Bars
@onready var bars2 = $Bars2
@onready var lock = $Lock
@onready var lock2 = $Lock2
@onready var particles = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_state(state)
	set_active(false)
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_portal_area_2d_body_entered(_body: Node2D) -> void:
	print("portal: id", portal_id)
	Signals.portal.emit(portal_id)

### update the portal visual according to new state
func set_state(new_state : State):
	if state != new_state:
		match state:
			State.LOCKED: await lock.dissolve_sprite()
			State.LOCKED2: await lock2.dissolve_sprite()
			State.BARS: await bars.dissolve_sprite()
			State.BARS2: await bars2.dissolve_sprite()
		
	state = new_state
	print("Portal:set_portal_state", state)
	bars.visible = false
	bars2.visible = false
	lock.visible = false
	lock2.visible = false
	
	match state:
		State.LOCKED: lock.visible = true
		State.LOCKED2: lock2.visible = true
		State.BARS: bars.visible = true
		State.BARS2: bars2.visible = true
		
### update the active state of the particles
func set_active(new_active: bool) -> void:
		active = new_active
		particles.visible = new_active

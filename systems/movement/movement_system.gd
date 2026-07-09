extends Node
class_name MovementSystem

signal facing_changed(dir: Vector2)

var fsm: FSM
var _systems_initialized: bool = false

# State Machines for Movement
var idle_state: IdleState
var move_state: MoveState
var dash_state: DashState
# end

# Movement System parameters
var _body: CharacterBody2D
var velocity := Vector2.ZERO
var direction := Vector2.ZERO
@export var last_non_zero_direction := Vector2.RIGHT
# end

# MovementData
@export var data : MovementResource
# end

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtains the movement system associated node's entity object which extends 
	# from (or is) CharacterBody2D
	var specific_entity = get_parent()
	
	# Ensure we are working with a CharacterBody2D
	if specific_entity is CharacterBody2D:
		_body = specific_entity
		specific_entity.systems_ready.connect(_on_systems_ready)
	else:
		push_error("MovementSystem's associated Node must be child of CharacterBody2D")
		return

	# Get movement data if present
	if "movement_data" in specific_entity:
		data = specific_entity.movement_data
	else:
		push_error("Entity has no movement_data configured or associated (speed, acceleration, etc), system failure")
		
	if _body.has_signal("walk"):
		_body.walk.connect(_on_walk_requested)
	else:
		push_error("Entity has no walk signal")
		
	if _body.has_signal("dash"):
		_body.dash.connect(_on_dash_requested)
	else:
		push_error("Entity has no dash signal")

func _on_systems_ready(movement: MovementSystem, _attack: AttackSystem, _anim: AnimationSystem):
	fsm = _body.fsm
	# Get the FSM from the entity if present
	if "fsm" in _body and _body.fsm != null:
		fsm = _body.fsm
	else:
		push_error("Entity has no FSM configured or associated, system failure")

	idle_state = IdleState.new("Idle")
	move_state = MoveState.new("Move")
	dash_state = DashState.new("Dash")
	
	for state in [idle_state, move_state, dash_state]:
		state.movement = self
		fsm.add_child(state)

	fsm.change_state(idle_state)
	call_deferred("_emit_initial_state")

	_systems_initialized = true
	

func _on_walk_requested(dir: Vector2):
	direction = dir.normalized() if dir != Vector2.ZERO else Vector2.ZERO
	if direction != Vector2.ZERO:
		if last_non_zero_direction != direction:
			last_non_zero_direction = direction
			facing_changed.emit(last_non_zero_direction)
			
func _on_dash_requested():
	if _systems_initialized and fsm:
		fsm.change_state(dash_state)

func _physics_process(delta: float) -> void:
	if not _systems_initialized or fsm == null:
		return
	
	fsm.update(delta)
	
	_body.velocity = velocity
	_body.move_and_slide()
	
func _emit_initial_state():
	if fsm and fsm.current_state:
		fsm.state_changed.emit(fsm.current_state)

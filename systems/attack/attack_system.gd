extends Node
class_name AttackSystem

# signal facing_changed(dir: Vector2)

var fsm: FSM
var _systems_initialized: bool = false

# State Machines for Attacks
var attack1_state: Attack1State
var idle_state: IdleState
# State Machines for Attacks - end

# Attack System parameters
var _body: CharacterBody2D
# Attack System parameters - end

# Attack System Data
@export var data : AttackResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtains the system associated node's entity object which extends 
	# from (or is) CharacterBody2D
	var specific_entity = get_parent()
	
	# Ensure we are working with a CharacterBody2D
	if specific_entity is CharacterBody2D:
		_body = specific_entity
		specific_entity.systems_ready.connect(_on_systems_ready)
	else:
		push_error("System's associated Node must be child of CharacterBody2D")
		return

	# Get movement data if present
	if "attack_data" in specific_entity:
		data = specific_entity.attack_data
	else:
		push_error("Entity has no attack_data configured or associated (speed, acceleration, etc), system failure")
		
	if _body.has_signal("attack"):
		_body.attack.connect(_on_attack_requested)
	else:
		push_error("Entity has no attack signal")

func _on_systems_ready(_movement: MovementSystem, _attack: AttackSystem, _anim: AnimationSystem):
	fsm = _body.fsm
	# Get the FSM from the entity if present
	if "fsm" in _body and _body.fsm != null:
		fsm = _body.fsm
	else:
		push_error("Entity has no FSM configured or associated, system failure")

	attack1_state = Attack1State.new("Attack1")
	
	for state in [attack1_state]:
		state.attack = self
		state.movement = _movement
		state.fsm = fsm
		fsm.add_child(state)

	_systems_initialized = true

func _physics_process(delta: float) -> void:
	if not _systems_initialized or fsm == null:
		return

	fsm.update(delta)
	

func _on_attack_requested():
	if _systems_initialized and fsm:
		fsm.change_state(attack1_state)
			

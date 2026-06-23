extends Node
class_name AttackSystem

# signal facing_changed(dir: Vector2)

# State Machines for Attacks
var fsm: AttackFSM
var attack1_state: Attack1State
# State Machines for Attacks - end

# Attack System parameters
var _body: CharacterBody2D
# Attack System parameters - end

# Attack System Data
@export var data : AttackResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fsm = AttackFSM.new(self)
	add_child(fsm)
	
	attack1_state = Attack1State.new("Attack1")
	
	for state in [attack1_state]:
		state.attack = self
		fsm.add_child(state)
		
	fsm.change_state(attack1_state)
	call_deferred("_emit_initial_state")
	
	# Obtains the system associated node's entity object which extends 
	# from (or is) CharacterBody2D
	var specific_entity = get_parent()
	
	# Ensure we are working with a CharacterBody2D
	if specific_entity is CharacterBody2D:
		_body = specific_entity
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
		
	pass

func _physics_process(delta: float) -> void:
	fsm.update(delta)
	
	pass
	
func _emit_initial_state():
	fsm.state_changed.emit(fsm.current_state)
	

func _on_attack_requested():
	pass
			

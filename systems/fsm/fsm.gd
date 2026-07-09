extends Node
class_name FSM

signal state_changed(new_state: State)

var prev_state: State
var current_state: State

var movement_system : MovementSystem
var attack_system : AttackSystem

func _init(movement = null, attack = null):
	movement_system = movement
	attack_system = attack

func change_state(new_state: State):
	if current_state == new_state:
		return
	if new_state.has_method("can_enter") and not new_state.can_enter():
		return
		
	if current_state:
		current_state.exit()
	
	prev_state = current_state
	current_state = new_state
	state_changed.emit(current_state)
	print("[FSM] → ", current_state.name)
	current_state.enter()
	
func update(delta):
	# actualizar todos los estados (cooldowns. timers. etc)
	for child in get_children():
		if child.has_method("tick"):
			child.tick(delta)
	
	if current_state:
		current_state.update(delta)

extends Node
class_name FSM

var current_state: State

func change_state(new_state: State):
	if current_state == new_state:
		return
	if new_state.has_method("can_enter") and not new_state.can_enter():
		return
		
	if current_state:
		current_state.exit()
		
	current_state = new_state
	print("[FSM] → ", current_state.name)
	current_state.enter()
	
func update(delta):
	# actualizar todos los estados (cooldowns. timers. etc)
	for child in get_children():
		if child.has_method("tick"):
			child.tick(delta)
	
	if current_state:
		current_state.update(delta)

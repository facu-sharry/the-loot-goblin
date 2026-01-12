extends MovementState
class_name DashState

var time_left := 0.0
var cooldown_left := 0.0

func _init(p_name: String):
	name = p_name
	
func can_enter() -> bool:
	return cooldown_left <= 0.0

func enter():
	time_left = movement.data.dash_duration
	movement.velocity = movement.last_non_zero_direction * movement.data.dash_speed

func update(delta):
	if time_left > 0.0:
		time_left -= delta
		if time_left <= 0:
			cooldown_left = movement.data.dash_cooldown
			movement.fsm.change_state(movement.idle_state)

func tick(delta):
	if cooldown_left > 0.0:
		cooldown_left -= delta

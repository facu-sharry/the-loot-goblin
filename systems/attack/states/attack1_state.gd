extends AttackState
class_name Attack1State

var time_left := 0.0
var cooldown_left := 0.0

func _init(p_name: String):
	name = p_name

func can_enter() -> bool:
	return cooldown_left <= 0.0

func enter():
	time_left = attack.data.attack_duration

func update(delta):
	if time_left > 0.0:
		time_left -= delta
		if time_left <= 0:
			cooldown_left = attack.data.attack_cooldown
			attack.fsm.change_state(movement.idle_state)

func tick(delta):
	if cooldown_left > 0.0:
		cooldown_left -= delta

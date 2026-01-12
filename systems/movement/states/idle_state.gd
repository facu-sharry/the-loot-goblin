extends MovementState
class_name IdleState

func _init(p_name: String):
	name = p_name

func update(delta):
	movement.velocity = movement.velocity.move_toward(
		Vector2.ZERO,
		movement.data.friction * delta
	)

	if movement.direction != Vector2.ZERO:
		movement.fsm.change_state(movement.move_state)

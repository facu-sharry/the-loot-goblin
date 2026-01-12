extends MovementState
class_name MoveState

func _init(p_name: String):
	name = p_name

func update(delta):
	var target_velocity = movement.direction * movement.data.speed

	movement.velocity = movement.velocity.move_toward(
		target_velocity,
		movement.data.acceleration * delta
	)

	if movement.direction == Vector2.ZERO:
		movement.fsm.change_state(movement.idle_state)

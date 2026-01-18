extends Node
class_name AnimationSystem

@onready var animator : AnimationPlayer = $"../AnimationPlayer"
@onready var sprite : Sprite2D = $"../Sprite2D"

func _ready():
	var movement = get_parent().get_node("MovementSystem")
	movement.fsm.state_changed.connect(_on_state_changed)
	movement.facing_changed.connect(_on_facing_changed)
	
func _on_state_changed(state: State):
	if not animator:
		push_error("Animator Player not found")
		return
	
	match state.name:
		"Idle":
			animator.play("idle")
		"Move":
			animator.play("walk")
		"Dash":
			animator.play("dash")

func _on_facing_changed(dir: Vector2):
	sprite.flip_h = dir.x < 0

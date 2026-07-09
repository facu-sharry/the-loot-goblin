extends Node
class_name AnimationSystem

@onready var animator : AnimationPlayer = $"../AnimationPlayer"
@onready var sprite : Sprite2D = $"../Sprite2D"

var _body: CharacterBody2D

func _ready():
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

func _on_systems_ready(_movement: MovementSystem, _attack: AttackSystem, _anim: AnimationSystem):
	# Connects the state_changed signal from the FSM to the animation system
	_body.fsm.state_changed.connect(_on_state_changed)

	var movement = _body.get_node("MovementSystem")
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
		"Attack1":
			animator.play("attack1")

func _on_facing_changed(dir: Vector2):
	sprite.flip_h = dir.x < 0

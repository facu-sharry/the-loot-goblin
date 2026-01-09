extends Node
class_name MovementSystem

var _body: CharacterBody2D
var speed : float = 120
var acceleration : float = 1200
var friction: float = 1200
var direction := Vector2.ZERO
var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtains the movement system associated node's entity object which extends 
	# from (or is) CharacterBody2D
	var specific_entity = get_parent()
	
	# Ensure we are working with a CharacterBody2D
	if specific_entity is CharacterBody2D:
		_body = specific_entity
	elif specific_entity.get_parent() is CharacterBody2D:
		_body = specific_entity.get_parent()
	else:
		push_error("MovementSystem's associated Node must be child of CharacterBody2D")
		return

	# Get movement data if present
	if "movement_data" in specific_entity:
		speed = specific_entity.movement_data.speed
		acceleration = specific_entity.movement_data.acceleration
		friction = specific_entity.movement_data.friction
	else:
		push_error("Entity has no movement_data, using system's defaults")
		
	if _body.has_signal("walk"):
		_body.walk.connect(_on_walk_requested)
	else:
		push_error("Entity has no move_requested signal")

func _on_walk_requested(dir: Vector2):
	direction = dir.normalized()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(
			direction * speed,
			acceleration * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			friction * delta
		)

	_body.velocity = velocity
	_body.move_and_slide()

extends Node
class_name MovementSystem

@export var acceleration : float = 1200.0
@export var friction : float = 800.0

var _body: Player
var _speed: float
var direction := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_body = get_parent() as Player
	_speed = _body.speed
	
	if _body.has_signal("move_requested"):
		_body.move_requested.connect(_on_move_requested)

func _on_move_requested(direction: Vector2):
	var target_velocity := direction * _speed
	_body.velocity = _body.velocity.move_toward(
		target_velocity,
		acceleration * get_physics_process_delta_time()
	)

func _physics_process(delta: float) -> void:
	if _body.velocity.length() > 0.0:
		_body.velocity = _body.velocity.move_toward(
			Vector2.ZERO,
			friction * delta
		)
	_body.move_and_slide()

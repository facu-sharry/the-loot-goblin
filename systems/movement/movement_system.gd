extends Node
class_name MovementSystem

enum MoveState { NORMAL, DASH}

var state: MoveState = MoveState.NORMAL

var _body: CharacterBody2D

var speed : float = 120
var acceleration : float = 1200
var friction: float = 1200
var velocity := Vector2.ZERO

var last_non_zero_direction := Vector2.RIGHT
var direction := Vector2.ZERO

var dash_speed: float = 800
var dash_duration: float = 0.0
var dash_cooldown: float = 1.0
var dash : bool = false
var dash_timer := 0.0
var dash_cooldown_left : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtains the movement system associated node's entity object which extends 
	# from (or is) CharacterBody2D
	var specific_entity = get_parent()
	
	# Ensure we are working with a CharacterBody2D
	if specific_entity is CharacterBody2D:
		_body = specific_entity
	else:
		push_error("MovementSystem's associated Node must be child of CharacterBody2D")
		return

	# Get movement data if present
	if "movement_data" in specific_entity:
		speed = _body.movement_data.speed
		dash_speed = _body.movement_data.dash_speed
		acceleration = _body.movement_data.acceleration
		friction = _body.movement_data.friction
		dash_duration = _body.movement_data.dash_duration
		dash_cooldown = _body.movement_data.dash_cooldown
	else:
		push_error("Entity has no movement_data, using system's defaults")
		
	if _body.has_signal("walk"):
		_body.walk.connect(_on_walk_requested)
	else:
		push_error("Entity has no walk signal")
		
	if _body.has_signal("dash"):
		_body.dash.connect(_on_dash_requested)
	else:
		push_error("Entity has no dash signal")

func _on_walk_requested(dir: Vector2):
	
	direction = dir.normalized() if state == MoveState.NORMAL else direction
	if direction.length() > 0 and state == MoveState.NORMAL:
		last_non_zero_direction = direction
	
func _on_dash_requested():
	if state != MoveState.NORMAL:
		return
		
	if dash_cooldown_left > 0.0:
		return
			
	state = MoveState.DASH
	dash_timer = dash_duration
	dash_cooldown_left = dash_cooldown

func _physics_process(delta: float) -> void:
	if dash_cooldown_left > 0.0:
		dash_cooldown_left -= delta
	
	match state:
		MoveState.DASH:
			_process_dash(delta)
		MoveState.NORMAL:
			_process_movement(delta)

	_body.velocity = velocity
	_body.move_and_slide()
	
func _process_movement(delta: float):
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
	
func _process_dash(delta: float):
	if dash_timer <= 0.0:
		state = MoveState.NORMAL
		return
	
	dash_timer -= delta
	
	velocity = last_non_zero_direction * dash_speed

extends CharacterBody2D
class_name Player

@export var movement_data : MovementResource
signal walk(direction: Vector2)
signal dash(dash: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void: 
	var raw_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	walk.emit(raw_direction)
	
	var dashed = Input.get_action_strength("dash")
	if dashed:
		dash.emit()

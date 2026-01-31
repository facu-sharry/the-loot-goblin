extends CharacterBody2D
class_name Player

@export var movement_data : MovementResource
signal walk(direction: Vector2)
signal dash(dash: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walk.emit(Vector2.ZERO)

func _process(_delta: float) -> void: 
	var raw_direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	)
	
	walk.emit(raw_direction)
	
	var dashed = Input.get_action_strength("dash")
	if dashed:
		dash.emit()

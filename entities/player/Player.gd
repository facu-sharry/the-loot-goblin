extends CharacterBody2D
class_name Player

@export var speed : float = 100.0
signal move_requested(direction: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void: 
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	move_requested.emit(direction)

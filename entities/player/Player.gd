extends CharacterBody2D
class_name Player

@export var movement_data: MovementResource
signal walk(direction: Vector2)
signal dash(dash: bool)

@export var attack_data: AttackResource
signal attack()

signal systems_ready(movement: MovementSystem, attack: AttackSystem, anim: AnimationSystem)

var fsm: FSM
var movement_system: MovementSystem
var attack_system: AttackSystem
var animation_system: AnimationSystem

func _ready() -> void:
	# PASO 1: Crear la FSM
	fsm = FSM.new()
	add_child(fsm)
	
	# PASO 2: Obtener referencias a los sistemas (ya existen en el árbol)
	movement_system = $MovementSystem
	attack_system = $AttackSystem
	animation_system = $AnimationSystem
	
	# PASO 3: Esperar a que los _ready() de los sistemas terminen
	#         Luego emitir la señal
	call_deferred("_on_all_systems_ready")

func _on_all_systems_ready() -> void:
	# PASO 4: Ahora los sistemas pueden usar fsm, movement_data, etc.
	systems_ready.emit(movement_system, attack_system, animation_system)
	
	# PASO 5: Input inicial
	walk.emit(Vector2.ZERO)

func _process(_delta: float) -> void: 
	var raw_direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	walk.emit(raw_direction)
	
	var dashed = Input.get_action_strength("dash")
	if dashed:
		dash.emit()
		
	var attacked = Input.get_action_strength("attack")
	if attacked:
		attack.emit()

class_name PlayerMovementAscending extends Node2D

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var grounded := PlayerMovementGrounded.first()

var elapsed : float = 0.0
var is_jump_cancelled : bool

func on_state_exit(_next:Node=null) -> void:
	elapsed = 0.0
	is_jump_cancelled = false

func on_state_enter(_prev:Node=null) -> void:
	elapsed = 0.0
	is_jump_cancelled = false

func apply_gravity(delta:float) -> void:
	if is_jump_cancelled:
		character.velocity.y += stats.jump_gravity_down * delta
	else:
		if character.get_meta('vent', false): return
		character.velocity.y += stats.jump_gravity_up * delta

func apply_directional_movement(delta:float) -> void:
	grounded.apply_directional_movement(delta)

func _physics_process(delta: float) -> void:
	is_jump_cancelled = is_jump_cancelled or input.is_jump_cancelled()

	apply_gravity(delta)
	apply_directional_movement(delta)

	character.move_and_slide()
	
	if character.velocity.y >= 0:
		machine_movement.transition(PlayerEnums.Movement.DESCENDING, 'fall')
		return
	if character.is_on_floor():
		machine_movement.transition(PlayerEnums.Movement.GROUNDED, 'land')
		return


const GROUP := 'player_movement_ascending'

func _enter_tree() -> void:
	add_to_group(GROUP)

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlayerMovementAscending: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

class_name PlayerMovementSwinging extends Node2D

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var grounded := PlayerMovementGrounded.first()

var is_jump : bool

func on_state_exit(_next:Node=null) -> void:
	is_jump = false

func on_state_enter(_prev:Node=null) -> void:
	is_jump = false

func apply_gravity(_delta:float) -> void:
	pass

func apply_directional_movement(_delta:float) -> void:
	pass

func _physics_process(delta: float) -> void:
	is_jump = input.is_jump_requested()

const GROUP := 'player_movement_swinging'

func _enter_tree() -> void:
	add_to_group(GROUP)

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlayerMovementSwinging: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

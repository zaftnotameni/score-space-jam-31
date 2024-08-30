class_name PlayerMovementCoyote extends Node2D

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var grounded := PlayerMovementGrounded.first()

var elapsed : float = 0.0
var is_jump : bool

func on_state_exit(_next:Node=null) -> void:
	elapsed = 0.0
	is_jump = false

func on_state_enter(_prev:Node=null) -> void:
	elapsed = 0.0
	is_jump = false

func apply_gravity(delta:float) -> void:
	grounded.apply_gravity(delta)

func apply_directional_movement(delta:float) -> void:
	grounded.apply_directional_movement(delta)

func apply_jump(delta:float) -> void:
	grounded.apply_jump(delta)

func _physics_process(delta: float) -> void:
	is_jump = input.is_jump_requested()

	apply_gravity(delta)
	apply_directional_movement(delta)

	if is_jump: apply_jump(delta)

	character.move_and_slide()
	
	if grounded.ground_transitions(is_jump):
		return

	if character.is_on_floor():
		machine_movement.transition(PlayerEnums.Movement.GROUNDED, 'uncoyote')
		return

	elapsed += delta
	if elapsed >= stats.coyote_duration:
		machine_movement.transition(PlayerEnums.Movement.DESCENDING, 'fell')

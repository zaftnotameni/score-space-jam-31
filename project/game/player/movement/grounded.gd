class_name PlayerMovementGrounded extends Node2D

const GROUP := 'player_movement_grounded'

func _enter_tree() -> void:
	add_to_group(GROUP)

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlayerMovementGrounded: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var grounded := PlayerMovementGrounded.first()

var elapsed : float = 0.0
var is_jump_cancelled : bool
var is_jump : bool

func on_state_exit(_next:Node=null) -> void:
	elapsed = 0.0
	is_jump_cancelled = false
	is_jump = false

func on_state_enter(_prev:Node=null) -> void:
	elapsed = 0.0
	is_jump_cancelled = false
	is_jump = false
	if machine_movement.previous_state_id() != PlayerEnums.Movement.COYOTE:
		if CameraFollowsPlayer.first():
			CameraFollowsPlayer.first().trauma_request(0.08, 0.1)

func apply_gravity(delta:float) -> void:
	character.velocity.y += stats.jump_gravity_down * delta

func apply_directional_movement(delta:float) -> void:
	var velocity_and_direction_match : bool = is_equal_approx(sign(character.velocity.x), sign(input.x()))
	var speed_is_above_default : bool = abs(character.velocity.x) > abs(stats.speed)

	if velocity_and_direction_match and speed_is_above_default:
		character.velocity.x = move_toward(character.velocity.x, stats.speed, stats.speed_loss_factor * delta)
	else:
		character.velocity.x = stats.speed * input.x()
	
	if character.is_on_floor():
		if abs(character.velocity.x) > 0:
			PlayerVisual.first().sprite_2d.play("Walking")
		else:
			PlayerVisual.first().sprite_2d.play("Idle")

func apply_jump(_delta:float) -> void:
	character.velocity.y = -stats.jump_velocity

func _physics_process(delta: float) -> void:
	is_jump = input.is_jump_requested()

	apply_gravity(delta)
	apply_directional_movement(delta)

	if is_jump: apply_jump(delta)

	character.move_and_slide()

	if ground_transitions(is_jump):
		return

	if not character.is_on_floor():
		machine_movement.transition(PlayerEnums.Movement.COYOTE, 'coyote')
		return

func ground_transitions(is_jmp:bool) -> bool:
	if is_jmp:
		machine_movement.transition(PlayerEnums.Movement.ASCENDING, 'jump')
		return true
	return false

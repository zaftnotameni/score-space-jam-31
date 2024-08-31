class_name PlayerMovementSwinging extends Node2D

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var grounded := PlayerMovementGrounded.first()

var is_jump : bool
var previous_velocity := Vector2.ZERO
var lamp : LampScene
var rotation_accel : float = 1.0
var max_rotation_speed : float = 2.0
var min_rotation_speed : float = 0.5
var rotation_speed : float = 1.0
var base_jump_off_speed : float = 300.0

func on_state_exit(_next:Node=null) -> void:
	is_jump = false
	lamp = null

func on_state_enter(_prev:Node=null) -> void:
	is_jump = false
	lamp = get_tree().current_scene.get_node(character.get_meta('lamp_selector', ''))
	if not lamp: push_error('invalid lamp'); return
	if not lamp.grab_area: push_error('invalid lamp.grab_area'); return

	character.global_position = lamp.grab_area.global_position
	character.remove_meta('lamp_selector')
	previous_velocity = character.velocity
	character.velocity = Vector2.ZERO

func apply_rotation(delta:float) -> void:
	match machine_direction.current_state_id():
		PlayerEnums.Direction.RIGHT:
			lamp.rotation = move_toward(lamp.rotation, -PI/4.0, delta * rotation_speed)
			if is_equal_approx(-PI/4.0, lamp.rotation):
				machine_direction.transition(PlayerEnums.Direction.LEFT, 'lamp-grab-turn-left')

		PlayerEnums.Direction.LEFT:
			lamp.rotation = move_toward(lamp.rotation, PI/4.0, delta * rotation_speed)
			if is_equal_approx(PI/4.0, lamp.rotation):
				machine_direction.transition(PlayerEnums.Direction.RIGHT, 'lamp-grab-turn-right')

func apply_directional_movement(delta:float) -> void:
	match machine_direction.current_state_id():
		PlayerEnums.Direction.RIGHT:
			if input.x() > 0:
				rotation_speed = move_toward(rotation_speed, max_rotation_speed, delta * rotation_accel)
			if input.x() < 0:
				rotation_speed = move_toward(rotation_speed, min_rotation_speed, delta * rotation_accel)

		PlayerEnums.Direction.LEFT:
			if input.x() < 0:
				rotation_speed = move_toward(rotation_speed, max_rotation_speed, delta * rotation_accel)
			if input.x() > 0:
				rotation_speed = move_toward(rotation_speed, min_rotation_speed, delta * rotation_accel)

func apply_jump(_delta:float) -> void:
	var speed := base_jump_off_speed * rotation_speed
	var direction := Vector2.ZERO
	if lamp.rotation < 0:
		direction = Vector2.RIGHT.rotated(lamp.rotation)
	if lamp.rotation > 0:
		direction = Vector2.LEFT.rotated(lamp.rotation)
	
	character.velocity = direction * speed
	character.move_and_slide()

	lamp.rotation = 0

	if character.velocity.y > 0:
		machine_movement.transition(PlayerEnums.Movement.DESCENDING, 'lamp-to-descending')
	else:
		machine_movement.transition(PlayerEnums.Movement.ASCENDING, 'lamp-to-ascending')

func _physics_process(delta: float) -> void:
	is_jump = input.is_jump_requested()
	if not lamp: return

	apply_rotation(delta)
	apply_directional_movement(delta)

	character.global_position = lamp.grab_area.global_position

	if is_jump: apply_jump(delta)

const GROUP := 'player_movement_swinging'

func _enter_tree() -> void:
	add_to_group(GROUP)

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlayerMovementSwinging: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

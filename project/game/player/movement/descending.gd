class_name PlayerMovementDescending extends Node2D

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var grounded := PlayerMovementGrounded.first()

func on_state_exit(_next:Node=null) -> void:
	pass

func on_state_enter(_prev:Node=null) -> void:
	PlayerVisual.first().sprite_2d.play("Jumping")

func apply_gravity(delta:float) -> void:
	if Input.is_action_pressed('player_jump'):
		character.velocity.y += stats.jump_gravity_down_gliding * delta
		if character.velocity.y >= stats.max_speed_from_gravity_gliding:
			character.velocity.y = stats.max_speed_from_gravity_gliding
	else:
		character.velocity.y += stats.jump_gravity_down * delta
		if character.velocity.y >= stats.max_speed_from_gravity:
			character.velocity.y = stats.max_speed_from_gravity

func apply_directional_movement(delta:float) -> void:
	grounded.apply_directional_movement(delta)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_directional_movement(delta)

	character.move_and_slide()
	
	if character.is_on_floor():
		machine_movement.transition(PlayerEnums.Movement.GROUNDED, 'land')
		return


const GROUP := 'player_movement_ascending'

func _enter_tree() -> void:
	add_to_group(GROUP)

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlayerMovementAscending: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

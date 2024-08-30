class_name PlayerInput extends Node2D

@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var character := CharacterScene.first()

const GROUP := 'player_input'

func x() -> float:
	return Input.get_axis('player_left', 'player_right')

func is_jump_requested() -> bool:
	return Input.is_action_just_pressed('player_jump')

func is_jump_cancelled() -> bool:
	return Input.is_action_just_released('player_jump')

func _enter_tree() -> void:
	add_to_group(GROUP)

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlayerInput: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

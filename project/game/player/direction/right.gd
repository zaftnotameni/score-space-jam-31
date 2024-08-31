class_name PlayerDirectionRight extends Node2D

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var visuals := PlayerVisual.first()

func _unhandled_input(event: InputEvent) -> void:
	if machine_movement.current_state_id() == PlayerEnums.Movement.SWINGING: return
	if event.is_action_pressed('player_left'):
		machine_direction.transition(PlayerEnums.Direction.LEFT, 'flip')

func on_state_enter(_prev:Node=null) -> void:
	visuals.scale.x = 1


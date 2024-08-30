class_name PlayerMovementInitial extends Node2D

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()
@onready var grounded := PlayerMovementGrounded.first()

func _physics_process(_delta: float) -> void:
	if character.is_on_floor():
		machine_movement.transition(PlayerEnums.Movement.GROUNDED, 'initial-ground')
	else:
		machine_movement.transition(PlayerEnums.Movement.DESCENDING, 'initial-air')

class_name PlayerMachines extends Node2D

@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	machine_movement.machine_mode = StateMachine.MACHINE_MODE.Physics
	machine_direction.machine_mode = StateMachine.MACHINE_MODE.Physics

	machine_movement.setup(PlayerEnums.Movement)
	machine_direction.setup(PlayerEnums.Direction)

	machine_movement.start(PlayerEnums.Movement.INITIAL)
	machine_direction.start(PlayerEnums.Direction.RIGHT)

	machine_movement.sig_state_will_transition.connect(state_will_change)
	machine_direction.sig_state_will_transition.connect(state_will_change)

func state_will_change(next:Node, curr:Node, prev:Node):
	printt(prev.name, curr.name, next.name)

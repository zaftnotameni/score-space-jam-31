class_name PlayerVisual extends Node2D

func on_animation_changed():
	pass

func animate_grounded():
	print_verbose('grounded')

func animate_dash():
	print_verbose('dash')

func animate_ascending():
	print_verbose('ascending')

func animate_descending():
	print_verbose('descending')

func animate_coyote_or_grounded():
	print_verbose('coyote or grounded')

func animate_default():
	animate_coyote_or_grounded()

func animate_coyote():
	print_verbose('coyote')
	animate_coyote_or_grounded()

func on_movement_state_machine_transition(_curr:Node=null,_prev:Node=null):
	cancel_animations()
	match machine_movement.current_state_id():
		PlayerEnums.Movement.ASCENDING: animate_ascending()
		PlayerEnums.Movement.DESCENDING: animate_descending()
		PlayerEnums.Movement.COYOTE: animate_coyote()
		PlayerEnums.Movement.GROUNDED: animate_grounded()
		_: animate_default()

func _ready() -> void:
	machine_movement.sig_state_did_transition.connect(on_movement_state_machine_transition)

func _exit_tree() -> void:
	tween_kill()

func tween_kill():
	if t and t.is_running(): t.kill()
	t = null

func tween_start():
	t = create_tween()
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func cancel_animations():
	tween_kill()

@onready var character := CharacterScene.first()
@onready var machine_movement := MovementMachine.first()
@onready var machine_direction := DirectionMachine.first()
@onready var stats := PlayerStats.first()
@onready var input := PlayerInput.first()

var t : Tween

const GROUP := 'player_visual'

func _enter_tree() -> void:
	add_to_group(GROUP)

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlayerVisual: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

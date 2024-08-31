class_name LampScene extends Node2D

@onready var grab_area : Area2D = %GrabArea
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D

func grab(character:CharacterScene, movement_machine:MovementMachine):
	character.set_meta('lamp_selector', get_path())
	movement_machine.transition(PlayerEnums.Movement.SWINGING, 'grabbed-lamp')

func on_character_entered(character:CharacterScene):
	var movement_machine := MovementMachine.first()
	if not movement_machine: push_error('tried to use movement machine when not available'); return

	match movement_machine.current_state_id():
		PlayerEnums.Movement.ASCENDING: grab(character, movement_machine)
		PlayerEnums.Movement.DESCENDING: grab(character, movement_machine)
		_: push_error('character should not be touching lamps when not in the air, double check level design')

func _ready() -> void:
	grab_area.body_entered.connect(on_body_entered)

func on_body_entered(body:Node):
	if body is CharacterScene: on_character_entered(body)

const GROUP := 'lamp_scene'

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> LampScene: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

func _enter_tree() -> void:
	add_to_group(GROUP)

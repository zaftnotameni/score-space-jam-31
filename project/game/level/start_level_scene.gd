class_name StartLevelScene extends Area2D

func on_character_entered(_character:CharacterScene):
	queue_free()
	LevelState.change_level_state_to_lava()

func on_body_entered(body:Node):
	if body is CharacterScene: on_character_entered(body)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	body_entered.connect(on_body_entered)


const GROUP := 'start_level_scene'

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> StartLevelScene: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

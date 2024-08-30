class_name FloorScene extends StaticBody2D

func _enter_tree() -> void:
	add_to_group(GROUP)

const GROUP := 'floor_scene'

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> FloorScene: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

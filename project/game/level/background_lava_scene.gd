class_name BackgroundLavaScene extends Node2D

func _enter_tree() -> void:
	add_to_group(GROUP)

const GROUP := 'background_lava_scene'

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> BackgroundLavaScene: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

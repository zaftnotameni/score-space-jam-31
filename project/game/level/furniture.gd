class_name Furniture extends CharacterBody2D

func _enter_tree() -> void:
	add_to_group(GROUP)

const GROUP := 'furniture'

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> Furniture: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

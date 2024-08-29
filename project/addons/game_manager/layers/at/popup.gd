class_name AtPopup extends Node

@export var scene : PackedScene

func _enter_tree() -> void:
	if not scene: push_error('must provide a scene %s' % get_path())
	Layers.layer_popup().add_child.call_deferred(scene.instantiate())

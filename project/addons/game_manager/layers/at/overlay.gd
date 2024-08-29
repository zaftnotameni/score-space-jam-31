class_name AtOverlay extends Node

@export var scene : PackedScene

func _enter_tree() -> void:
	if not scene: push_error('must provide a scene %s' % get_path())
	Layers.layer_overlay().add_child.call_deferred(scene.instantiate())

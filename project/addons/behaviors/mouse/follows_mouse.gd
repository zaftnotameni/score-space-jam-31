class_name FollowsMouseBehavior extends Node

@export var target : Node2D
@export var snap : Vector2 = Vector2(1, 1)

func _enter_tree() -> void:
	if not target and get_parent() is Node2D: target = get_parent()
	if not target and owner is Node2D: target = owner
	if not target: push_error('missing target')

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	var viewport := get_viewport()
	var camera := viewport.get_camera_2d()
	target.global_position = camera.get_global_mouse_position() if camera else viewport.get_mouse_position()
	target.global_position = target.global_position.snapped(snap)

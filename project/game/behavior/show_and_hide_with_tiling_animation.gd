class_name ShowAndHideWithTilingAnimation extends Node

@export var time_in : float = 0.2
@export var time_out : float = 0.4
@export var target : Control

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT if Engine.is_editor_hint() else ProcessMode.PROCESS_MODE_ALWAYS
	if not target: target = get_parent()

func _ready() -> void:
	target.material = Gen_AllMaterials.MATERIAL_SQUARES_SCREEN_TRANSITION_SHADER
	animate.call_deferred()

func animate():
	var t := TweenUtil.tween_ignores_pause(TweenUtil.tween_fresh_eased_in_out_cubic())
	t.tween_method(
		func(value): target.material.set_shader_parameter('fade', value),
		1.0,  # Start value
		0.0,  # End value
		time_in
	)
	t.tween_method(
		func(value): target.material.set_shader_parameter('fade', value),
		0.0,  # Start value
		1.0,  # End value
		time_out
	)
	t.tween_callback(target.queue_free)

class_name Pauseable extends Node

## pause screen scene
@export var scene : PackedScene

@export_category('optional')
@export var target : Node

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT if Engine.is_editor_hint() else ProcessMode.PROCESS_MODE_ALWAYS
	if not target: target = get_parent()
	target.process_mode = Node.PROCESS_MODE_PAUSABLE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('pause'):
		get_viewport().set_input_as_handled()
		set_process_unhandled_input(false)
		on_pause()

func on_pause():
	get_tree().paused = true
	State.push_paused()
	var instance : Control = scene.instantiate()
	var tween := TweenUtil.tween_ignores_pause(TweenUtil.tween_fresh_eased_in_out_cubic())
	Layers.layer_menu().add_child.call_deferred(instance)
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	tween.parallel().tween_property(instance, ^'position:y', 0, 0.3).from(Config.viewport_height)
	instance.tree_exited.connect(on_unpaused)

func on_unpaused():
	if is_queued_for_deletion(): return
	get_tree().paused = false
	set_process_unhandled_input(true)
	State.pop_paused()

func _ready() -> void:
	if not scene: push_error('missing scene on %s' % get_path())

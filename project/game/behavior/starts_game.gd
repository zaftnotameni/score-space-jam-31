class_name StartsGame extends Node

@export_group('optional')
@export var menu : Control
@export var scene : PackedScene
@export var button : BaseButton

func on_pressed():
	var instance : Node2D = scene.instantiate()
	State.transition_start()
	Layers.layer_game().add_child.call_deferred(instance)
	var tween := TweenUtil.tween_ignores_pause(TweenUtil.tween_fresh_eased_in_out_cubic())
	tween.parallel().tween_property(menu, ^'position:x', -Config.viewport_width, 0.3).from(0)
	await tween.finished
	State.transition_finish()
	menu.queue_free()

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT if Engine.is_editor_hint() else ProcessMode.PROCESS_MODE_ALWAYS
	if not button: button = get_parent()
	if not menu: menu = owner
	if not button.text or button.text.is_empty(): button.text = 'Start'

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if not scene: push_error('missing scene on %s' % get_path())
	if not button: push_error('missing button on %s' % get_path())
	if not menu: push_error('missing menu on %s' % get_path())
	button.pressed.connect(on_pressed)

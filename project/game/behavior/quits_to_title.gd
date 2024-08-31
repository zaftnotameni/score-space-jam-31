class_name QuitsToTitle extends Node

@export_group('optional')
@export var scene : PackedScene
@export var button : BaseButton
@export var menu : Control

func wipe_all(children:Array=[]):
	for child in children: child.queue_free()

func on_pressed():
	var instance := scene.instantiate()
	menu.add_sibling(instance)

	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	tween.tween_property(menu, ^'position:y', -Config.viewport_height, 0.3).from(0)
	tween.parallel().tween_property(instance, ^'position:y', 0, 0.3).from(Config.viewport_height)

	await tween.finished
	owner.queue_free()
	Layers.clear_all_layers([instance])

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT if Engine.is_editor_hint() else ProcessMode.PROCESS_MODE_ALWAYS
	if not button: button = get_parent()
	if not menu: menu = owner
	if not button.text or button.text.is_empty(): button.text = 'Options'

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if not scene: push_error('missing scene on %s' % get_path())
	if not button: push_error('missing button on %s' % get_path())
	button.pressed.connect(on_pressed)

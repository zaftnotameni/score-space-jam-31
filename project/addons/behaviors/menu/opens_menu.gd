class_name OpensMenu extends Node

@export var menu_scene : PackedScene
@export var button : BaseButton

var tween : Tween

func open_menu():
	if not button: push_error('missing button'); return
	if not menu_scene: push_error('missing menu scene'); return

	var menu := menu_scene.instantiate() as Node
	if not menu: push_error('missing menu'); return

	disconnect_signals()
	if button.has_focus(): button.release_focus()

	button.pressed.connect(on_pressed)
	menu.tree_exited.connect(button.grab_focus)
	menu.tree_exited.connect(connect_signals)

	menu.position.x = Config.viewport_width
	menu.set_meta('opened_by', owner.get_path())
	owner.add_sibling(menu)
	tween = TweenUtil.tween_ignores_pause(TweenUtil.tween_fresh_eased_in_out_cubic(tween))
	tween.tween_property(owner, 'position:x', -Config.viewport_width, 0.2).from(0.0)
	tween.tween_property(menu, 'position:x', 0, 0.2).from(Config.viewport_width)

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT if Engine.is_editor_hint() else ProcessMode.PROCESS_MODE_ALWAYS
	if not button and get_parent() is BaseButton: button = get_parent()
	if not button and owner is BaseButton: button = owner
	if button: button.process_mode = process_mode

func _ready() -> void:
	connect_signals()

func connect_signals():
	if not button: return
	if not button.pressed.is_connected(on_pressed):
		button.pressed.connect(on_pressed, CONNECT_ONE_SHOT)

func disconnect_signals():
	if not button: return
	if button.pressed.is_connected(on_pressed):
		button.pressed.disconnect(on_pressed)

func _exit_tree() -> void:
	TweenUtil.tween_kill(tween)

func on_pressed():
	open_menu()


class_name ClosesMenu extends Node

var title_scene := load('res://game/screen/title_screen.tscn')

func close_target():
	if not target_menu: return

	var title : Node
	var path := target_menu.get_meta('opened_by', '')
	if not path:
		if State.is_initial():
			title = title_scene.instantiate()
			Layers.layer_menu().add_child(title)
		else:
			target_menu.queue_free(); return

	printt(get_tree(), get_tree().current_scene)
	var opener := get_tree().current_scene.get_node_or_null(path) if path else title
	if not opener:
		if State.is_initial():
			opener = title
		else:
			target_menu.queue_free(); return

	var tween : Tween
	tween = TweenUtil.tween_ignores_pause(TweenUtil.tween_fresh_eased_in_out_cubic(tween))
	tween.tween_property(target_menu, 'position:x', Config.viewport_width, 0.2).from(0.0)
	tween.tween_property(opener, 'position:x', 0, 0.2).from(-Config.viewport_width)
	tween.tween_callback(target_menu.queue_free)

func _ready() -> void:
	if target_button:
		if not target_button.text or target_button.text.is_empty():
			target_button.text = "Close"
		target_button.pressed.connect(close_target, CONNECT_ONE_SHOT)

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT if Engine.is_editor_hint() else ProcessMode.PROCESS_MODE_ALWAYS
	if not target_menu: target_menu = find_closeable_parent()
	if not target_button: target_button = get_parent()
	if target_button:
		target_button.process_mode = process_mode

func _unhandled_input(event: InputEvent) -> void:
	if TARGET_ACTIONS.any(event.is_action_pressed):
		get_viewport().set_input_as_handled()
		close_target()

func find_closeable_parent(n:Node=self) -> Node:
	if TARGET_GROUPS.any(n.is_in_group): return n
	if TARGET_META.any(n.has_meta): return n
	if n is PanelContainer: return n
	return owner

const TARGET_GROUPS = [
	"popup",
	"menu",
	"sub_menu",
	"closeable",
]

const TARGET_META = [
	"popup",
	"menu",
	"sub_menu",
	"closeable",
]

const TARGET_ACTIONS = [
	"menu_close",
	"menu_back",
]

@export var target_menu : Node
@export var target_button : BaseButton


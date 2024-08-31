class_name ShowsCurrentDistance extends Node

@export var line_edit : LineEdit
@export var label : Label

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT if Engine.is_editor_hint() else ProcessMode.PROCESS_MODE_ALWAYS
	if not line_edit and get_parent() is LineEdit: line_edit = get_parent()
	if not line_edit and owner is LineEdit: line_edit = owner
	if not label and get_parent() is Label: label = get_parent()
	if not label and owner is Label: label = owner

func _ready() -> void:
	if not line_edit and not label: push_error('missing line_edit or label on %s' % get_path())

func _process(_delta: float) -> void:
	if line_edit and State.current_score > 0:
		line_edit.text = str(State.current_score) + 'm'
	if label and State.current_time > 0:
		label.text = str(State.current_score) + 'm'

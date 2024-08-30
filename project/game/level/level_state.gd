class_name LevelState extends Node2D

signal sig_level_state_changed()

enum Stage { FLOOR = 0, LAVA, DINNER }

var stage := Stage.FLOOR

static func change_level_state_to_lava():
	var state := LevelState.first()
	if not state: push_error('using level state when it is not available'); return
	state.stage = Stage.LAVA
	state.sig_level_state_changed.emit()
	var lava := LavaScene.first()
	var the_floor := FloorScene.first()
	if not lava: push_error('using lava when it is not available'); return
	if not the_floor: push_error('using lava when it is not available'); return
	var t := TweenUtil.tween_fresh_eased_in_out_cubic()
	t.tween_property(lava, 'global_position', Vector2(the_floor.global_position.x, the_floor.global_position.y), 0.2)
	t.tween_property(the_floor, 'global_position', Vector2(lava.global_position.x, lava.global_position.y), 0.2)

func _enter_tree() -> void:
	add_to_group(GROUP)

const GROUP := 'level_state'
static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> LevelState: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

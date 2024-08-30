class_name LevelState extends Node2D

signal sig_level_state_changed()

enum Stage { FLOOR = 0, LAVA, DINNER }

var stage := Stage.FLOOR

static var game_over_screen_scene : PackedScene = load('res://game/screen/game_over_screen.tscn')

static func change_level_state_to_dinner():
	Layers.layer_menu().add_child.call_deferred(game_over_screen_scene.instantiate())

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

func on_character_enter_lava(character:CharacterScene):
	character.process_mode = Node.PROCESS_MODE_DISABLED
	character.queue_free()
	LavaScene.first().owner.queue_free()
	LevelState.change_level_state_to_dinner()

func on_body_enter_lava(body:Node2D):
	if body is CharacterScene: on_character_enter_lava(body)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	var lava := LavaScene.first()
	if lava:
		lava.body_entered.connect(on_body_enter_lava)

const GROUP := 'level_state'
static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> LevelState: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

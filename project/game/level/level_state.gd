class_name LevelState extends Node2D

signal sig_level_state_changed()

enum Stage { FLOOR = 0, LAVA, DINNER }

var stage := Stage.FLOOR

static var game_over_screen_scene : PackedScene = load('res://game/screen/game_over_screen.tscn')

static func change_level_state_to_floor():
	var lava_fg := LavaScene.first()
	var lava_bg := BackgroundLavaScene.first()
	if not lava_fg: push_error('trying to use lava when it does not exist'); return
	if not lava_bg: push_error('trying to use lava when it does not exist'); return
	original_lava_fg_position = Vector2(lava_fg.global_position.x, lava_fg.global_position.y)
	original_lava_bg_position = Vector2(lava_bg.global_position.x, lava_bg.global_position.y)
	lava_fg.position.y += Config.viewport_height
	lava_bg.position.y += Config.viewport_height

static var original_lava_fg_position : Vector2
static var original_lava_bg_position : Vector2

static func change_level_state_to_dinner():
	Layers.layer_menu().add_child.call_deferred(game_over_screen_scene.instantiate())

static func change_level_state_to_lava():
	var state := LevelState.first()
	if not state: push_error('using level state when it is not available'); return
	if state.stage == Stage.LAVA: return
	if state.stage == Stage.DINNER: push_warning('invalid state transition dinner -> lava'); return
	state.stage = Stage.LAVA
	state.sig_level_state_changed.emit()
	var lava := LavaScene.first()
	var lava_bg := BackgroundLavaScene.first()
	var the_floor := FloorScene.first()
	if not lava: push_error('using lava when it is not available'); return
	if not lava_bg: push_error('using lava when it is not available'); return
	if not the_floor: push_error('using lava when it is not available'); return
	var t := TweenUtil.tween_fresh_eased_in_out_cubic()
	t.tween_property(lava, 'global_position', Vector2(the_floor.global_position.x, the_floor.global_position.y), 0.2)
	t.parallel().tween_property(lava_bg, 'global_position', original_lava_bg_position, 0.2)

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
	LevelState.change_level_state_to_floor.call_deferred()
	var lava := LavaScene.first()
	if lava:
		lava.body_entered.connect(on_body_enter_lava)

const GROUP := 'level_state'
static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> LevelState: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

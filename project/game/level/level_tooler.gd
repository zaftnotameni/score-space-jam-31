@tool
class_name LevelTooler extends Node

@export var tooled : bool = true : set = set_tooled

var character_scene : PackedScene = load('res://game/player/character.tscn')

func on_tooled():
	if not Engine.is_editor_hint(): return
	if not ToolUtil.is_owned_by_edited_scene(self): return
	ToolUtil.remove_all_children_created_via_tool_from(self)
	var spawner := PlayerSpawner.new()
	spawner.active = true
	spawner.spawn_on_ready = true
	spawner.scene = character_scene
	spawner.name = 'PlayerSpawner'
	var camera : Camera2D = Camera2D.new()
	camera.name = 'Camera'
	camera.zoom = Vector2(1, 1)
	camera.process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
	var camera_follows_player : CameraFollowsPlayer = CameraFollowsPlayer.new()
	camera_follows_player.name = 'CameraFollowsPlayer'
	var game : Node = StateGame.new()
	game.name = 'StateGame'
	var unpauses : Node = Unpauses.new()
	unpauses.name = 'Unpauses'
	var pauseable : Node = Pauseable.new()
	pauseable.name = 'Pauseable'
	var sets_target_as_pause_screen : Node = SetsTargetAsPauseScreen.new()
	sets_target_as_pause_screen.name = 'SetsTargetAsPauseScreen'
	await ToolUtil.tool_add_child(owner, spawner)
	await ToolUtil.tool_add_child(owner, camera)
	await ToolUtil.tool_add_child(camera, camera_follows_player)
	await ToolUtil.tool_add_child(owner, game)
	await ToolUtil.tool_add_child(owner, unpauses)
	await ToolUtil.tool_add_child(owner, pauseable)
	await ToolUtil.tool_add_child(pauseable, sets_target_as_pause_screen)


func set_tooled(v:bool):
	ToolUtil.set_tooled(self, v)


class_name SetsTargetAsLeaderboardsScreen extends Node

var scene := load('res://game/screen/leaderboard_screen.tscn')

func _enter_tree() -> void:
	get_parent().set('scene', scene)

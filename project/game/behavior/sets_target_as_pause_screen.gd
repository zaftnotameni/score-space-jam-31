class_name SetsTargetAsPauseScreen extends Node

var scene := load('res://game/screen/pause_screen.tscn')

func _enter_tree() -> void:
	get_parent().set('scene', scene)

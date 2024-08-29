class_name SetsTargetAsTitleScreen extends Node

var scene := load('res://game/screen/title_screen.tscn')

func _enter_tree() -> void:
	get_parent().set('scene', scene)

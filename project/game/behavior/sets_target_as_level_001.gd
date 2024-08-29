class_name SetsTargetAsLevel001 extends Node

var scene := load('res://game/level/level_001.tscn')

func _enter_tree() -> void:
	get_parent().set('scene', scene)

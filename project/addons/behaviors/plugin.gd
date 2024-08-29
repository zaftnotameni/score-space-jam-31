@tool
extends EditorPlugin

const CHILD_LABOR_AUTOLOAD_NAME := "ChildLabor"

func _enter_tree() -> void:
#add_autoload_singleton(CHILD_LABOR_AUTOLOAD_NAME, "./child_labor/autoload.tscn")
	pass

func _exit_tree() -> void:
#remove_autoload_singleton(CHILD_LABOR_AUTOLOAD_NAME)
	pass

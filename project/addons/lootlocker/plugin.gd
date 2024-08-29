@tool
extends EditorPlugin

const LOOTLOCKER_AUTOLOAD_NAME := "LootlockerAPI"

func _enter_tree() -> void:
	add_autoload_singleton(LOOTLOCKER_AUTOLOAD_NAME, "./lootlocker/autoload.tscn")

func _exit_tree() -> void:
	remove_autoload_singleton(LOOTLOCKER_AUTOLOAD_NAME)

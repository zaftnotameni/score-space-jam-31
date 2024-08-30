extends Node

const FURNITURE = preload("res://game/level/furniture.tscn")

@onready var furniture_spawn_timer: Timer = $FurnitureSpawnTimer
@onready var furniture_spawn_point: Marker2D = $FurnitureSpawnPoint


func _ready() -> void:
	furniture_spawn_timer.timeout.connect(_spawn_timer_timeout)
	furniture_spawn_timer.start()


func _physics_process(delta: float) -> void:
	for furniture in Furniture.all():
		furniture.position.x -= 10 * delta


func _spawn_timer_timeout():
	var furniture_instance = FURNITURE.instantiate()
	furniture_instance.position = furniture_spawn_point.position
	add_child(furniture_instance)
	print("furniture spawned")

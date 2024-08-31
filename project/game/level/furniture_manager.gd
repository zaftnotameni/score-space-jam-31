extends Node2D

const FURNITURE = preload("res://game/level/furniture.tscn")


@export var furniture_margin : float = 20
@export var furniture_speed : float = 1000
@export var sink_speed : float = 10

var last_furniture : Furniture


func _ready() -> void:
	spawn_furniture()


func _physics_process(delta: float) -> void:
	for furniture in Furniture.all():
		furniture.position.x -= furniture_speed * delta
		furniture.position.y += sink_speed * delta


func spawn_furniture(location : Vector2 = global_position) -> void:
	var furniture_instance = FURNITURE.instantiate()
	add_child(furniture_instance)
	furniture_instance.global_position.y = global_position.y
	furniture_instance.position.x = location.x + furniture_instance.sprite_2d.texture.get_size().x + furniture_margin
	furniture_instance.visible_on_screen_notifier_2d.screen_entered.connect(_furniture_entered_screen.bind(furniture_instance))
	last_furniture = furniture_instance
	print("furniture spawned")


func _furniture_entered_screen(furniture : Furniture) -> void:
	if furniture.visible_on_screen_notifier_2d.screen_entered.is_connected(_furniture_entered_screen):
		furniture.visible_on_screen_notifier_2d.screen_entered.disconnect(_furniture_entered_screen)
		spawn_furniture(last_furniture.position)

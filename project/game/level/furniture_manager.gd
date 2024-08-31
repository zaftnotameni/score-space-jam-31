extends Node2D

const FURNITURE = preload("res://game/level/furniture.tscn")

@onready var spawn_point : Marker2D = $SpawnPoint

@export var furniture_margin : float = 20
@export var furniture_speed : float = 1000
@export var sink_speed : float = 10


func _ready() -> void:
	# Furniture Objects are not being deleted when hitting restart in the game
	for i in get_children():
		if i is Furniture:
			i.queue_free()
	
	spawn_furniture()


func _physics_process(delta: float) -> void:
	for furniture in Furniture.all():
		furniture.position.x -= furniture_speed * delta
		furniture.position.y += sink_speed * delta


func spawn_furniture(location : Vector2 = Vector2.ZERO) -> void:
	var furniture_instance = FURNITURE.instantiate()
	
	add_child(furniture_instance)
	
	furniture_instance.position.x = location.x + furniture_instance.sprite_2d.texture.get_size().x + furniture_margin
	furniture_instance.visible_on_screen_notifier_2d.screen_entered.connect(_furniture_entered_screen.bind(furniture_instance))
	
	print("input: ",location, " + ", location.x + furniture_instance.sprite_2d.texture.get_size().x + furniture_margin)
	print("Furniture local: ", furniture_instance.position, " | Furniture Global: ",furniture_instance.global_position)


func _furniture_entered_screen(furniture : Furniture) -> void:
	# Disconnecting signal so that only that only the last furniture piece can spawn a new one 
	if furniture.visible_on_screen_notifier_2d.screen_entered.is_connected(_furniture_entered_screen):
		furniture.visible_on_screen_notifier_2d.screen_entered.disconnect(_furniture_entered_screen)
		spawn_furniture(furniture.position)

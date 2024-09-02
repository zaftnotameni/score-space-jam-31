class_name ObstacleSpawnerScene extends Marker2D

const furniture_scene : PackedScene = preload("res://game/obstacles/furniture.tscn")
const lamp_scene : PackedScene = preload("res://game/obstacles/lamp.tscn")

@export var furniture_margin : float = 20.0
@export var sink_speed : float = 10.0

var minimum_angle : float = -PI/10.0
var maximum_angle : float = PI/10.0

var sinking_enabled : bool = false

func _ready() -> void:
	smart_spawn_first_obstacle()
	var level_state := LevelState.first()
	if not level_state: push_error('missing level state'); return
	level_state.sig_level_state_changed.connect(on_level_state_changed)
	set_physics_process(sinking_enabled)

func smart_spawn_first_obstacle():
	var existing_furniture := FurnitureScene.all()

	if existing_furniture and not existing_furniture.is_empty():
		spawn_furniture(to_local(existing_furniture[-1].global_position))
	else:
		spawn_furniture()

func on_level_state_changed():
	var level_state := LevelState.first()
	if not level_state: push_error('missing level state'); return
	sinking_enabled = level_state.stage == LevelState.Stage.LAVA
	set_physics_process(sinking_enabled)


func _physics_process(delta: float) -> void:
	for furniture in FurnitureScene.all():
		if not furniture.visible_on_screen_notifier_2d.is_on_screen(): continue
		furniture.position.y += (sink_speed + randf_range(-4,4)) * delta


func spawn_furniture(local_position_of_previous_obstacle : Vector2 = Vector2.ZERO) -> void:
	var furniture_instance = furniture_scene.instantiate()
	
	add_child(furniture_instance)
	
	furniture_instance.position.x = local_position_of_previous_obstacle.x + furniture_instance.sprite_2d.texture.get_size().x + furniture_margin + randf_range(-20, 400)
	furniture_instance.rotate(randf_range(minimum_angle, maximum_angle))
	var notifier := furniture_instance.visible_on_screen_notifier_2d as VisibleOnScreenNotifier2D
	if not notifier: push_error('no notifier'); return
	
	notifier.screen_entered.connect(_furniture_entered_screen.bind(furniture_instance), CONNECT_ONE_SHOT)


func spawn_lamp(local_position_of_previous_obstacle : Vector2 = Vector2.ZERO) -> void:
	var lamp_instance = lamp_scene.instantiate()
	
	add_child(lamp_instance)
	
	lamp_instance.position.y = -1330
	lamp_instance.position.x = local_position_of_previous_obstacle.x + (furniture_margin * 1.5)
	
	# Lamps are not currently being destroyed
	# If I make a world border collision to delete objects then it also deletes the cubes before their position gets set



func _furniture_entered_screen(furniture : FurnitureScene) -> void:
	spawn_furniture(furniture.position)
	
	if !randi_range(0,3):
		spawn_lamp(furniture.position)

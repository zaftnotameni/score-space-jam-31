class_name FurnitureManagerScene extends Marker2D

const FURNITURE = preload("res://game/level/furniture.tscn")

@export var furniture_margin : float = 20
@export var furniture_speed : float = 1000
@export var sink_speed : float = 10

var sinking_enabled : bool = false

func _ready() -> void:
	spawn_furniture()
	var level_state := LevelState.first()
	if not level_state: push_error('missing level state'); return
	level_state.sig_level_state_changed.connect(on_level_state_changed)
	set_physics_process(sinking_enabled)

func on_level_state_changed():
	var level_state := LevelState.first()
	if not level_state: push_error('missing level state'); return
	sinking_enabled = level_state.stage == LevelState.Stage.LAVA
	set_physics_process(sinking_enabled)

func _physics_process(delta: float) -> void:
	for furniture in Furniture.all():
		furniture.position.x -= furniture_speed * delta
		furniture.position.y += sink_speed * delta

func spawn_furniture(location : Vector2 = Vector2.ZERO) -> void:
	var furniture_instance = FURNITURE.instantiate()
	
	add_child(furniture_instance)
	
	furniture_instance.position.x = location.x + furniture_instance.sprite_2d.texture.get_size().x + furniture_margin
	var notifier := furniture_instance.visible_on_screen_notifier_2d as VisibleOnScreenNotifier2D
	if not notifier: push_error('no notifier'); return

	notifier.screen_entered.connect(_furniture_entered_screen.bind(furniture_instance), CONNECT_ONE_SHOT)
	
	print_verbose("input: ",location, " + ", location.x + furniture_instance.sprite_2d.texture.get_size().x + furniture_margin)
	print_verbose("Furniture local: ", furniture_instance.position, " | Furniture Global: ",furniture_instance.global_position)

func _furniture_entered_screen(furniture : Furniture) -> void:
	spawn_furniture(furniture.position)

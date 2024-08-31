class_name Furniture extends CharacterBody2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var occluder: LightOccluder2D = $LightOccluder2D

var potential_furniture_sizes : Array[Vector2i] = [
	Vector2i(320, 320),
	Vector2i(160, 480),
	Vector2i(640, 160),
	Vector2i(480, 160),
]

func _ready() -> void:
	if not sprite_2d: return
	if not collision: return
	occluder.add_child(collision.duplicate())

func _enter_tree() -> void:
	add_to_group(GROUP)

const GROUP := 'furniture'

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> Furniture: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)

func destroy() -> void:
	queue_free()

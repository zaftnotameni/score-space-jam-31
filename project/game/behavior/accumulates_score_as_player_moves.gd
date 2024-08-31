class_name AccumulatesScoreAsPlayerMoves extends Node

@onready var character := CharacterScene.first()
@onready var spawner := PlayerSpawner.first()

var distance_travelled : int = 0

func _ready() -> void:
	var state := State.first()
	if not character and state:
		await state.sig_player_ready
		character = CharacterScene.first()
		set_process(true)

func _process(_delta: float) -> void:
	if not character: set_process(false); return
	if not spawner: set_process(false); return
	if character.is_queued_for_deletion(): set_process(false); return
	if spawner.is_queued_for_deletion(): set_process(false); return
	
	distance_travelled = max(distance_travelled, 0.005 * (character.global_position.x - spawner.global_position.x))
	var new_score = max(State.current_score, distance_travelled)
	State.update_score(new_score)
	printt(distance_travelled, new_score)

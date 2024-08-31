class_name PublishesHighScore extends Node

func _ready() -> void:
	if State.current_score > 0:
		State.promote_current_score_to_victory_score()
		Lootlocker.upload_score(State.victory_score)

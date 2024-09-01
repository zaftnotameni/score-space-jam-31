class_name FurnitureKiller extends Area2D

func _ready() -> void:
	body_entered.connect(_body_entered)

func _body_entered(body : Node2D) -> void:
	if body.has_method("destroy"):
		print("Deleting ", body)
		body.destroy()

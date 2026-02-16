extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

func _on_body_entered(body: Node2D) -> void:
	print("hello")

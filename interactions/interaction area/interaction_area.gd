extends Area2D
class_name InteractionArea

@export var action_name: String = " INTERACT"

var interact : Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:
	pass
	
func _on_body_exited(body: Node2D) -> void:
	pass

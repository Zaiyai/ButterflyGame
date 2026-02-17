extends Area2D
class_name InteractionArea

@export var action_name: String = " INTERACT"

var interact : Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:
	InteractionManagerScene.register_area(self)
	


func _on_body_exited(body: Node2D) -> void:
	InteractionManagerScene.unregister_area(self)

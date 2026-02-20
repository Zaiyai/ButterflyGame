extends Area2D
class_name InteractionArea

var is_being_fed_on := false
var has_player := false

@export var text : String 

@onready var label = $Label

func _ready() -> void:
	label.text = text

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		has_player = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		has_player = false

func _process(_delta: float) -> void:
	if has_player and Input.is_action_just_pressed("interact"):
		queue_free()

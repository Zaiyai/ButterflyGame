extends Node2D

@export var num := 10 

func _ready() -> void:
	for butterfly in num:
		spawnButterfly()

func spawnButterfly():
	var butterfly = Global.butterfly.instantiate()
	add_child(butterfly)
	butterfly.modulate = Color(
		randi_range(1,5), 
		randi_range(1,5),
		randi_range(1,5), 
		1)
	butterfly.position = Vector2(randi_range(0, 10), randi_range(0, 10))

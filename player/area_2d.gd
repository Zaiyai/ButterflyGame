extends Area2D

var target_pos = Vector2.ZERO
var moving = false
const MOVEMENT_SPEED = 200  # Adjust speed as needed

func _physics_process(delta: float) -> void:
	if moving:
		position = position.move_toward(target_pos, MOVEMENT_SPEED * delta)
		if position.distance_to(target_pos) < 5:  # Stop moving when close enough
			moving = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		target_pos = event.position
		moving = true

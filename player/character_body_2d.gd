extends CharacterBody2D
var speed = 100

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	position += input_direction * delta * speed
	move_and_slide()

extends CharacterBody2D

var speed = 200
var click_position = Vector2()
var target_position = Vector2()
var rotation_speed = 10

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	click_position = global_position
		
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("left click"):
		click_position = get_global_mouse_position()
		var target_dir = (click_position - global_position).angle()
		if rotation != target_dir:
			rotation = lerp_angle(global_rotation, target_dir, rotation_speed * delta)
		else:
			look_at(click_position)
	if position.distance_to(click_position) > 10:
		target_position = (click_position - global_position).normalized()
		velocity = target_position * speed
		
		move_and_slide()

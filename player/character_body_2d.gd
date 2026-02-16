extends CharacterBody2D

var speed = 200
var click_position = Vector2()
var target_position = Vector2()

@onready var animation_tree = $AnimationTree

func _ready():
	click_position = global_position
	
func _physics_process(_delta):
	
	if Input.is_action_just_pressed("left click"):
		click_position = get_global_mouse_position()
	
	if position.distance_to(click_position) > 3:
		target_position = (click_position - global_position).normalized()
		velocity = target_position * speed
		move_and_slide()

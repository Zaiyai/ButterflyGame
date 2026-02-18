extends CharacterBody2D

var speed = 200
var click_position = Vector2()
var target_position = Vector2()

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	click_position = global_position
		
	
func _physics_process(_delta):
	
	if Input.is_action_just_pressed("left click"):
		click_position = get_global_mouse_position()
		look_at(get_global_mouse_position() )
	
	if position.distance_to(click_position) > 10:
		target_position = (click_position - global_position).normalized()
		velocity = target_position * speed
		
		move_and_slide()

func _on_camera_zoom_area_body_entered(body: Node2D) -> void:
	$Camera2D.zoom = Vector2(1, 1);


func _on_camera_zoom_area_body_exited(body: Node2D) -> void:
	$Camera2D.zoom = Vector2(1.8,1.8);

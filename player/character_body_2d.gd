extends CharacterBody2D

# Player Movement Variables
var speed = 200
var acceleration = 1000
var friction = 1000
var clickPosition = Vector2()
var clickDistance = Vector2()
var clickTargetRot: float = 0.0
var rotationSpeed: float  = 6.0


# Camera Zoom Control Variables
var zoomOutSpd = 0.5;
var zoomDefSpd = 0.8;
var zoomDefault = Vector2(1.8,1.8)
var zoomOut = Vector2(1,1);
var playerInArea = false

# Player Movement Animation Variables
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

# Mouse Position Check
func _ready():
	clickPosition = global_position

func _physics_process(delta):

# Mouse Position Check and Turn
	if Input.is_action_just_pressed("left click"):
		clickPosition = get_global_mouse_position()
		clickTargetRot = global_position.angle_to_point(clickPosition)
		
	rotation = lerp_angle(rotation, clickTargetRot, rotationSpeed * delta)
	
	if abs(angle_difference(rotation, clickTargetRot)) < 0.2:
		rotation = clickTargetRot

# Player Movement
	
	if position.distance_to(clickPosition) > 25:
		var forwardFace: Vector2 = Vector2.RIGHT.rotated(rotation)
		velocity = velocity.move_toward(forwardFace * speed, acceleration * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

# Camera Zoom Controller
	if playerInArea:
		$Camera2D.zoom = $Camera2D.zoom.lerp(zoomOut, zoomOutSpd * delta)
	else:
		$Camera2D.zoom = $Camera2D.zoom.lerp(zoomDefault, zoomDefSpd * delta)

# Camera Zoom Area Checker
func _on_camera_zoom_area_body_entered(body: Node2D) -> void:
	playerInArea = true

func _on_camera_zoom_area_body_exited(body: Node2D) -> void:
	playerInArea = false

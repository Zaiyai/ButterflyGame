extends CharacterBody2D

# Player Movement Variables
var speed = 200
var acceleration = 1000
var friction = 1000
var clickPosition = Vector2()
var clickDistance = Vector2()
var clickTargetRot: float = 0.0
var rotationSpeed: float  = 6.0

# Variable deciding if the click was close to the player
var closeClick := false

# Camera Zoom Control Variables
var zoomOutSpd = 0.5;
var zoomDefSpd = 0.8;
var zoomDefault = Vector2(1.8,1.8)
var zoomOut = Vector2(1,1);
var playerInArea = false

# Player Movement Animation Variables
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

# Children
@onready var grassLayer : TileMapLayer = get_parent().get_node("Grass")
@onready var camera : Camera2D = $Camera2D
@onready var camera_label : Label = $Camera2D/Label

var can_move: bool = true

#Cutscene check
func _on_cut_scene_end() -> void:
	camera_label.visible = true
	
func _on_cut_scene_exit() -> void:
	camera_label.visible = false
	can_move = true
	camera.zoom = zoomDefault
	camera.position = Vector2.ZERO

func _on_cut_scene_switch(targetPosition: Vector2) -> void:
	can_move = false
	camera.zoom = Vector2.ONE
	camera.global_position = targetPosition

# Mouse Position Check
func _ready():
	clickPosition = global_position

func _physics_process(delta):
	var forwardFace: Vector2 = Vector2.RIGHT.rotated(rotation)
	
	# Mouse Position Check and Turn
	if can_move and Input.is_action_just_pressed("left_click"):
		var initialClickPosition = get_global_mouse_position()
		
		# If click is inside tilemap
		if grassLayer.get_cell_source_id(grassLayer.local_to_map(initialClickPosition)) != -1:
			clickPosition = initialClickPosition
			clickTargetRot = global_position.angle_to_point(clickPosition)
			closeClick = false
			
			if position.distance_to(clickPosition) <= 35:
				closeClick = true

	# Player Move
	if can_move:
		if not closeClick:
			if position.distance_to(clickPosition) > 25:
					var desired_angle = global_position.angle_to_point(clickPosition)
					rotation = lerp_angle(rotation, desired_angle, rotationSpeed * delta)
					velocity = velocity.move_toward(forwardFace * speed, acceleration * delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		else: # If close click
			if position.distance_to(clickPosition) > 5:
				velocity = velocity.move_toward(position.direction_to(clickPosition) * speed, (acceleration * delta)/3)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	# Camera Zoom Controller
	if playerInArea:
		camera.zoom = camera.zoom.lerp(zoomOut, zoomOutSpd * delta)
	else:
		camera.zoom = camera.zoom.lerp(zoomDefault, zoomDefSpd * delta)
	
	if camera_label.visible:
		camera_label.position = camera.global_position - Vector2(100, -100)

# Camera Zoom Area Checker
func _on_camera_zoom_area_body_entered(_body: Node2D) -> void:
	playerInArea = true

func _on_camera_zoom_area_body_exited(_body: Node2D) -> void:
	playerInArea = false

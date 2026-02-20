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

# Tilemap layer
@onready var grassLayer : TileMapLayer = get_parent().get_node("Grass")

var can_move: bool = true

#Cutscene check
func _on_cut_scene_cutscene_end() -> void:
	can_move = can_move

func _on_cut_scene_cutscene_switch() -> void:
	can_move = !can_move

# Mouse Position Check
func _ready():
	clickPosition = global_position

func _physics_process(delta):
	var forwardFace: Vector2 = Vector2.RIGHT.rotated(rotation)

#Player Control
	if can_move:
		# Mouse Position Check and Turn
		if Input.is_action_just_pressed("left click"):
			var initialClickPosition = get_global_mouse_position()
		
			# If click is inside tilemap
			if grassLayer.get_cell_source_id(grassLayer.local_to_map(initialClickPosition)) != -1:
				clickPosition = initialClickPosition
				clickTargetRot = global_position.angle_to_point(clickPosition)
				closeClick = false
				
				if position.distance_to(clickPosition) <= 35:
					closeClick = true

		# Player Move
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
		
		move_and_slide()

# Camera Zoom Controller
	if playerInArea:
		$Camera2D.zoom = $Camera2D.zoom.lerp(zoomOut, zoomOutSpd * delta)
	else:
		$Camera2D.zoom = $Camera2D.zoom.lerp(zoomDefault, zoomDefSpd * delta)

# Camera Zoom Area Checker
func _on_camera_zoom_area_body_entered(_body: Node2D) -> void:
	playerInArea = true

func _on_camera_zoom_area_body_exited(_body: Node2D) -> void:
	playerInArea = false

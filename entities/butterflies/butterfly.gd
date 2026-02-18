extends Area2D

@onready var rays := $Rays.get_children()
@export var speed := 2.0
var butterfliesISee := []
var vel := Vector2.ONE
var screensize : Vector2
var movv := 48

var rng = RandomNumberGenerator.new().randi_range(0, 10)

func _ready() -> void:
	screensize = get_viewport_rect().size
	position += Vector2(rng, rng)
	randomize()

func _physics_process(_delta: float) -> void:
	boids()
	checkCollision()
	vel = vel.normalized() * speed
	move()
	rotation = lerp_angle(rotation, vel.angle_to_point(Vector2.ZERO), 0.4)

func move():
	global_position += vel
	#if global_position.x < 0:
		#global_position.x = screensize.x
	#if global_position.x > 0:
		#global_position.x = screensize.x
	#if global_position.y < 0:
		#global_position.x = screensize.y
	#if global_position.y > 0:
		#global_position.x = screensize.y

func boids():
	if butterfliesISee:
		var numberOfButterflies := butterfliesISee.size()
		var avgVel := Vector2.ZERO
		var avgPos := Vector2.ZERO
		var steerAway := Vector2.ZERO
		
		for butterfly in butterfliesISee:
			avgVel += butterfly.vel
			avgPos += butterfly.position
			steerAway -= (butterfly.global_position - global_position) * (movv/(global_position - butterfly.global_position).length())
		
		avgVel /= numberOfButterflies
		vel += (avgVel - vel)/2
		
		avgPos /= numberOfButterflies
		vel += (avgPos - position)
		
		steerAway /= numberOfButterflies
		vel += (steerAway)
	
func checkCollision():
	for ray in rays:
		var r : RayCast2D = ray
		if r.is_colliding():
			if r.get_collider().is_in_group("tree"):
				var magi := 100/(r.get_collision_point() - global_position).length_squared()
				vel -= (r.cast_to.rotated(rotation) * magi)

func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("butterfly NPC"):
		butterfliesISee.append(area)

func _on_vision_area_exited(area: Area2D) -> void:
	if area:
		butterfliesISee.erase(area)

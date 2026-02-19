extends Area2D

@onready var rays := $Rays.get_children()
@export var speed := 2.0
var butterfliesISee := []
var vel := Vector2.ONE
var flower_target : Node2D = null
var movv := 48
var flowerSenseCount := 0
var is_feeding := false
var last_vel := Vector2.ONE

var rng = RandomNumberGenerator.new().randi_range(0, 10)

func _ready() -> void:
	$AnimationPlayer.play("fly")

func _physics_process(_delta: float) -> void:
	if $Timer.time_left <= 0:
		boids()
		vel = vel.normalized() * speed
		move()
		rotation = lerp_angle(rotation, vel.angle_to_point(Vector2.ZERO), 0.4)

func move():
	global_position += vel

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
		
		last_vel = vel
		
	if flower_target and butterfliesISee.size() == 0:
		print(flower_target.is_being_fed_on)
		if flower_target.is_being_fed_on:
			flower_target = null
		else:
			var desired = (flower_target.global_position - global_position).normalized() * speed
			vel += (desired - vel) * 0.3
			
			if flowerSenseCount > 1:
				$Timer.start()
				flower_target.is_being_fed_on = true
				vel = Vector2.ZERO
				flower_target = null
				flowerSenseCount = 0
				is_feeding = true
	
func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("butterfly NPC") and area.flower_target == null:
		butterfliesISee.append(area)

func _on_vision_area_exited(area: Area2D) -> void:
	if area:
		butterfliesISee.erase(area)

func _on_flower_sense_area_entered(area: Area2D) -> void:
	if area.is_in_group("flower") and !area.is_being_fed_on:
		flower_target = area

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("flower_hitbox"):
		flowerSenseCount += 1

func _on_timer_timeout() -> void:
	is_feeding = false
	vel = last_vel

extends CharacterBody2D
class_name MusicalCueCharacter

enum Note {
	A, Bb, B, C, Db, D, Eb, E, F, Gb, G, Ab
}

const SPEED = 300.0
@export var note : Note
@export var audio : AudioStream
@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audioPlayer.stream = audio
	var effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("PitchShiftBus"), 0)
	if effect is AudioEffectPitchShift:
		effect.pitch_scale += note

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("hello")
		audioPlayer.play()
		#animation.start(gtfo)

extends CharacterBody2D
class_name MusicalCueCharacter

var character : MusicalCharacters.Character
@export var note : MusicalCharacters.Note
@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audioPlayer.stream = MusicalCharacters.get_character_note(character, note)

func _on_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		audioPlayer.play()
		visible = false
		#animation.start(gtfo)

func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		visible = true

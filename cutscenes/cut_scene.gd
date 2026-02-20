@tool
extends Area2D
class_name CutScene

enum Type {DIALOGUE, PICTURE}

var _type := Type.DIALOGUE
var _dialogue_entries: DialogueEntry
var can_end := false
var cutscene_ongoing := false
signal cutscene_switch
signal cutscene_end
signal cutscene_exit

@onready var textLabel : Label = $Label
@onready var timer : Timer = $Timer
@onready var labelTimer : Timer = $Label/Timer
@onready var animation : AnimationPlayer = $AnimationPlayer

@export var type: Type:
	get:
		return _type
	set(value):
		if _type == value:
			return
		_type = value
		notify_property_list_changed()

func _get_property_list():
	var properties = []
	
	if _type == Type.DIALOGUE:
		properties.append({
			"name": "dialogue",
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "DialogueEntry",
			"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		})
	
	return properties

func _get(property):
	if property == "dialogue":
		return _dialogue_entries

func _set(property, value):
	if property == "dialogue":
		_dialogue_entries = value
		return true
	return false

@onready var camera = get_parent().get_node("Player/Camera2D")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if type == Type.DIALOGUE:
			cutscene_ongoing = true
			emit_signal("cutscene_switch", _dialogue_entries)
			
			animation.play("fadeIn")
			
			labelTimer.wait_time = _dialogue_entries.duration - 1.00
			
			textLabel.text = _dialogue_entries.text
			textLabel.global_position = _dialogue_entries.position
			
			timer.wait_time = _dialogue_entries.duration
			timer.start()

func _process(_delta: float) -> void:
	if cutscene_ongoing and timer.is_stopped() and Input.is_action_just_pressed("left_click"):
		cutscene_ongoing = false
		emit_signal("cutscene_exit")

func _on_timer_timeout() -> void:
	emit_signal("cutscene_end")

func _on_label_timer_timeout() -> void:
	animation.play("fadeOut")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeIn":
		labelTimer.start()

@tool
extends Area2D
class_name CutScene

enum Type {DIALOGUE, PICTURE}

var _type := Type.DIALOGUE
var _dialogue_entries: Array[DialogueEntry] = []
var dialogueAmount : int = 1

var can_end := false
var cutscene_ongoing := false
var last_dialogue := false
signal cutscene_switch
signal cutscene_end
signal cutscene_exit

@onready var textLabel : Label = $Label
@onready var timer : Timer = $Timer
@onready var labelTimer : Timer = $Label/Timer
@onready var animation : AnimationPlayer = $AnimationPlayer

@export var positionNode : Node2D
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
			"name": "dialogueAmount",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,50,1",
			"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		})
		
		for i in range(dialogueAmount):
			properties.append({
				"name": "dialogue_%d" % i,
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "DialogueEntry",
				"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
			})
	
	return properties

func _get(property):
	if property == "dialogueAmount":
		return dialogueAmount
	if property.begins_with("dialogue_"):
		var index = property.get_slice("_", 1).to_int()
		if index < _dialogue_entries.size():
			return _dialogue_entries[index]

func _set(property, value):
	if property == "dialogueAmount":
		dialogueAmount = value
		_dialogue_entries.resize(dialogueAmount)
		call_deferred("notify_property_list_changed")
		return true
	if property.begins_with("dialogue_"):
		var index = property.get_slice("_", 1).to_int()
		if index >= _dialogue_entries.size():
			_dialogue_entries.resize(index + 1)
		_dialogue_entries[index] = value
		return true
	return false

@onready var camera : Camera2D = get_parent().get_node("Player/Camera2D")
var targetPosition : Vector2 = Vector2.ZERO

func _ready() -> void:
	var viewportSize : Vector2 = Vector2(get_viewport().size)
	targetPosition = positionNode.position + Vector2(viewportSize.x / 3.5, -viewportSize.y / 4)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if type == Type.DIALOGUE:
			for i in _dialogue_entries.size():
				if i == _dialogue_entries.size() - 1:
					last_dialogue = true
				var dialogue_entry : DialogueEntry = _dialogue_entries[i]
				
				cutscene_ongoing = true
				emit_signal("cutscene_switch", targetPosition)
				
				animation.play("fadeIn")
				
				labelTimer.wait_time = dialogue_entry.duration - 1.00
				
				textLabel.text = dialogue_entry.text
				textLabel.global_position = targetPosition + Vector2(0, -150)
				
				timer.wait_time = dialogue_entry.duration
				timer.start()
				await timer.timeout

func _process(_delta: float) -> void:
	if cutscene_ongoing and timer.is_stopped() and Input.is_action_just_pressed("left_click"):
		cutscene_ongoing = false
		emit_signal("cutscene_exit")
		queue_free()

func _on_timer_timeout() -> void:
	if last_dialogue:
		emit_signal("cutscene_end")

func _on_label_timer_timeout() -> void:
	animation.play("fadeOut")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeIn":
		labelTimer.start()

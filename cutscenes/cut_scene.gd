@tool
extends Area2D
class_name CutScene

enum Type {DIALOGUE, PICTURE}

var _type := Type.DIALOGUE
var _dialogue_entries: DialogueEntry
signal cutscene_switch
signal cutscene_end

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
	
func show_dialogue():
	$dialogueFade.play("fade_in")
func hide_dialogue():
	$dialogueFade.play("fade_out")

@onready var camera = get_parent().get_node("Player/Camera2D")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if type == Type.DIALOGUE:
			
			show_dialogue.call()
			
			camera.zoom = Vector2.ONE
			camera.global_position = _dialogue_entries.position
			
			emit_signal("cutscene_switch")
			
			var textLabel = Label.new()
			add_child(textLabel)
			textLabel.text = _dialogue_entries.text
			textLabel.global_position = _dialogue_entries.position
			
			var textduration = Timer.new()
			add_child(textduration)
			textduration.one_shot = true
			textduration.wait_time = _dialogue_entries.duration
			textduration.start()
			
			if textduration.is_stopped() == true:
				print("Timer has stopped")
				if Input.is_action_just_pressed("left click"):
					emit_signal("cutscene_end")
					hide_dialogue.call()

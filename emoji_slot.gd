class_name EmojiSlot
extends PanelContainer


signal pressed(_data: EmojiData)


@export var data: EmojiData:
	set(value):
		data = value
		label.text = data.emoji if data != null else ""


@onready var label: Label = $Label


func _ready() -> void:
	if data != null:
		label.text = data.emoji


func _on_gui_input(event: InputEvent) -> void:
	var mouse_event := event as InputEventMouseButton
	if mouse_event != null and mouse_event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		pressed.emit(data)

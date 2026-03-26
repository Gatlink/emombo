class_name EmojiSlot
extends Button


signal selected(slot: EmojiData)


@export var data: EmojiData:
	set(value):
		data = value
		text = data.emoji if data != null else ""


func _ready() -> void:
	if data != null:
		text = data.emoji


func _on_pressed() -> void:
	selected.emit(data)

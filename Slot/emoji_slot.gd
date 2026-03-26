class_name EmojiSlot
extends Button


signal selected(emoji: String)


func _on_pressed() -> void:
	selected.emit(text)

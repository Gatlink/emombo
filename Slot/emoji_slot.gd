class_name EmojiSlot
extends Button


func _on_pressed() -> void:
	if text in Game.selected:
		Game.unselect(text)
	else:
		Game.select(text)

class_name EmojiSlot
extends Button


@onready var animation: AnimationPlayer = $AnimationPlayer


func _on_pressed() -> void:
	if text in Game.selected:
		Game.unselect(text)
	else:
		Game.select(text)


func right() -> void:
	animation.play("right")


func wrong() -> void:
	animation.play("wrong")


func reset() -> void:
	animation.play("RESET")

extends HBoxContainer


const EMOJI_SLOT := preload("uid://b3gq0sxauhq2t")


@onready var to_find: EmojiSlot = $PanelContainer/VBoxContainer/ToFind
@onready var hint_label: Label = $PanelContainer/VBoxContainer/HintLabel
@onready var grid: GridContainer = $PanelContainer/VBoxContainer/Grid
@onready var combo: HBoxContainer = $PanelContainer/VBoxContainer/Combo
@onready var life_bar: HBoxContainer = $PanelContainer/VBoxContainer/LifeBar


func _ready() -> void:
	for child in grid.get_children():
		var slot := child as EmojiSlot
		if slot != null:
			slot.selected.connect(on_grid_emoji_selected)
	
	update_to_find()
	update_grid()
	update_combo()
	update_health()


func _on_validate_button_pressed() -> void:
	if Game.is_selection_valid():
		Game.end_game()
		if Game.queue.size() > 0:
			Game.start_game()
			on_new_game()
	else:
		Game.health -= 1
		update_health()


func on_grid_emoji_selected(emoji: EmojiData) -> void:
	if Game.selected.has(emoji):
		Game.unselect(emoji)
	else:
		Game.select(emoji)
	
	update_combo()


func on_new_game() -> void:
	update_to_find()
	update_grid()
	update_combo()
	update_health()


func update_to_find() -> void:
	to_find.text = Game.queue.front().emoji
	hint_label.text = "Indice : " + Game.queue.front().hint


func update_grid() -> void:
	for i in Game.POOL_SIZE:
		var slot := grid.get_child(i) as EmojiSlot
		slot.data = Game.pool[i]


func update_combo() -> void:
	for i in Game.MAX_SELECTED_COUNT:
		var slot := combo.get_child(i) as EmojiSlot
		if i < Game.selected.size():
			slot.data = Game.selected[i]
			slot.show()
		else:
			slot.hide()


func update_health() -> void:
	for i in Game.MAX_HEALTH:
		var heart := life_bar.get_child(i) as Label
		heart.text = "❤️" if i < Game.health else "🖤"

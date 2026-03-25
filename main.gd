extends HBoxContainer


const EMOJI_PATH := "res://Emojis/"
const EMOJI_SLOT := preload("uid://b3gq0sxauhq2t")


@onready var to_find: EmojiSlot = $PanelContainer/VBoxContainer/ToFind
@onready var hint_label: Label = $PanelContainer/VBoxContainer/HintLabel
@onready var grid: GridContainer = $PanelContainer/VBoxContainer/Grid
@onready var combo: HBoxContainer = $PanelContainer/VBoxContainer/Combo


var emoji_pool: Array[EmojiData] = []
var emoji_queue: Array[EmojiData] = []
var selected: Array[EmojiSlot] = []


func _ready() -> void:
	for file_name in DirAccess.get_files_at(EMOJI_PATH):
		var data := load(EMOJI_PATH + file_name) as EmojiData
		if data == null:
			continue
		
		if data.combo.size() == 0:
			emoji_pool.append(data)
		else:
			emoji_queue.append(data)
	
	for child in grid.get_children():
		var slot := child as EmojiSlot
		if slot != null:
			slot.pressed.connect(on_grid_emoji_pressed)
	
	for child in combo.get_children():
		selected.append(child as EmojiSlot)
	
	emoji_queue.sort_custom(func (a: EmojiData, b: EmojiData): return a.combo.size() < b.combo.size())
	start_game(emoji_queue.front())


func start_game(target_emoji: EmojiData) -> void:
	to_find.data = target_emoji
	hint_label.text = "Indice : %s" % target_emoji.hint
	
	generate_grid(target_emoji)
	
	var combo_count := combo.get_child_count()
	for i in target_emoji.combo.size():
		var slot := combo.get_child(i) as EmojiSlot
		slot.data = null
		slot.show()
	
	for i in range(target_emoji.combo.size(), combo_count):
		combo.get_child(i).hide()


func generate_grid(target_emoji: EmojiData) -> void:
	emoji_pool.shuffle()
	var grid_count := grid.get_child_count()
	for i in grid_count:
		var slot := grid.get_child(i) as EmojiSlot
		slot.data = emoji_pool[i]
	
	for emoji in target_emoji.combo:
		if not is_in_grid(emoji):
			var slot := grid.get_child(randi_range(0, grid_count - 1)) as EmojiSlot
			if slot != null:
				slot.data = emoji


func is_in_grid(emoji: EmojiData) -> bool:
	for child in grid.get_children():
		var slot := child as EmojiSlot
		if slot != null and slot.data == emoji:
			return true
	
	return false


func on_grid_emoji_pressed(emoji: EmojiData) -> void:
	var empty_index := -1
	for i in selected.size():
		if selected[i].data == emoji:
			selected[i].data = null
			return
		
		if empty_index == -1 and selected[i].data == null:
			empty_index = i
	
	if empty_index >= 0:
		selected[empty_index].data = emoji

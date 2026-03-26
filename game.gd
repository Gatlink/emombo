extends Node


const EMOJI_PATH := "res://Emojis/"
const POOL_SIZE := 16
const MAX_SELECTED_COUNT := 5
const MAX_HEALTH := 4


# All emojis which can appear in the pool
var emojis: Array[EmojiData] = []
# Emojis that will be proposed to the player to combine
var pool: Array[EmojiData] = []
# Emojis the player must find to win (first one is the one currently being guessed)
var queue: Array[EmojiData] = []
# Emojis selected by the player
var selected: Array[EmojiData] = []
# Attempts left in the current game
var health: int


func _ready() -> void:
	for file_name in DirAccess.get_files_at(EMOJI_PATH):
		var data := load(EMOJI_PATH + file_name) as EmojiData
		if data == null:
			continue
		
		if data.combo.size() == 0:
			emojis.append(data)
		else:
			queue.append(data)
	
	queue.sort_custom(func (a: EmojiData, b: EmojiData): return a.combo.size() < b.combo.size())
	start_game()


func start_game() -> void:
	generate_pool()
	selected.resize(queue.front().combo.size())
	selected.fill(null)
	health = MAX_HEALTH


func end_game() -> void:
	emojis.append(queue.pop_front())


func generate_pool() -> void:
	emojis.shuffle()
	pool = emojis.slice(0, POOL_SIZE)
	for emoji in queue.front().combo:
		if not pool.has(emoji):
			pool[randi() % POOL_SIZE] = emoji


func select(emoji: EmojiData) -> void:
	for i in selected.size():
		if selected[i] == null:
			selected[i] = emoji
			return


func unselect(emoji: EmojiData) -> void:
	for i in selected.size():
		if selected[i] == emoji:
			selected[i] = null
			return


func is_selection_valid() -> bool:
	for emoji in selected:
		if emoji == null or not queue.front().combo.has(emoji):
			return false
	return true

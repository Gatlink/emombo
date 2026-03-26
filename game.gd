extends Node


const EMOJI_PATH := "res://Emojis/"
const POOL_SIZE := 16
const MAX_SELECTED_COUNT := 5
const MAX_HEALTH := 4

# All emojis which can appear in the pool
var emojis := "☠️👽🤖🐕🐈🐅🐎🦏🐄🐖🐑🐪🦘🦥🦨🐘🐀🐇🐿️🦫🦎🐊🐢🐍🐉🦦🦈🐬🦭🐋🐟🦀🦆🐓🦩🦉🐧🦇🐌🐛🦟🪱🦗🐜🪳🐝🐞🧟🦴🦷🧠🫀🫅👮🕵️🥷🧑‍⚕️🧑‍🍳🧑‍🚀🧙🧛👂💪👃🎈🧨🎄🎞️🎠🎪🎨🧵🛒👓🦺🧦👑🎩⚽🏀🏈🎳🎯🥋🏆🕹️🎲🪩♟️🎤🎷🎸🗝️🧬💊🔬🧪🩸🛡️💡📖🖌️⌛🍟🍿🧀🥫🥩🫖🍯🍫🧊🍅🍄🥕🌼🌳🚗🛹🛼🚲✈️🚀🛸⛽🌍🏔️🏖️🏠⛩️🗽🌧️🌕☀️💧🔥☂️"
# Emojis that will be proposed to the player to combine
var pool: Array[String] = []
# Emojis the player must find to win (first one is the one currently being guessed)
var queue: Array[EmojiData] = []
# Emojis selected by the player
var selected: Array[String] = []
# Attempts left in the current game
var health: int
# Indices used to create the pool
var indexes: Array[int] = []


func _ready() -> void:
	for file_name in DirAccess.get_files_at(EMOJI_PATH):
		var data := load(EMOJI_PATH + file_name) as EmojiData
		if data == null:
			continue
		
		queue.append(data)
	
	queue.sort_custom(func (a: EmojiData, b: EmojiData): return a.combo.length() < b.combo.length())
	pool.resize(POOL_SIZE)
	start_game()


func start_game() -> void:
	generate_pool()
	selected.resize(queue.front().combo.length())
	selected.fill("")
	health = MAX_HEALTH


func end_game() -> void:
	emojis += queue.pop_front().emoji


func generate_indexes() -> void:
	for i in emojis.length():
		indexes.append(i)
	indexes.shuffle()


func generate_pool() -> void:
	pool.clear()
	for i in POOL_SIZE:
		if indexes.size() == 0:
			generate_indexes()
		
		var index: int = indexes.pop_front()
		pool.append(emojis[index])
	
	var to_find: EmojiData = queue.front()
	for i in to_find.combo.length():
		if not pool.has(to_find.combo[i]):
			pool[randi() % POOL_SIZE] = to_find.combo[i]


func select(emoji: String) -> void:
	for i in selected.size():
		if selected[i].is_empty():
			selected[i] = emoji
			return


func unselect(emoji: String) -> void:
	for i in selected.size():
		if selected[i] == emoji:
			selected[i] = ""
			return


func is_selection_valid() -> bool:
	for emoji in selected:
		if emoji == "" or not queue.front().combo.find(emoji) >= 0:
			return false
	return true

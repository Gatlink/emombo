extends Node


const EMOJI_PATH := "res://Emojis/"
const POOL_SIZE := 16
const MAX_SELECTED_COUNT := 4
const MAX_HEALTH := 4
const EMOJIS := "☠️,🤖,🐕,🐈,🐅,🐎,🦏,🐄,🐖,🐑,🐪,🦘,🦥,🦨,🐘,🐀,🐇," \
	+ "🦫,🦎,🐊,🐢,🐍,🦦,🐬,🦭,🐋,🐟,🦀,🦆,🐓,🦩,🦉,🐧,🦇,🐌,🐛,🦟," \
	+ "🦗,🐜,🪳,🐝,🐞,🦴,🦷,🧠,🫀,🫅,👮,🕵️,🧑‍⚕️,🧑‍🚀,💪,👃,🎈,🧨,🎄," \
	+ "🎞️,🎪,🎨,🧵,🛒,👓,🦺,🧦,👑,🎩,⚽,🏀,🏈,🎳,🎯,🥋,🏆,🕹️,🎲,🪩," \
	+ "♟️,🎤,🎷,🎸,🗝️,🧬,💊,🔬,🧪,🩸,🛡️,💡,🖌️,⌛,🍿,🧀,🥩,🫖,🍫,🧊," \
	+ "🍅,🍄,🥕,🌳,🚗,🛹,🛼,🚲,✈️,🚀,🛸,🛳️,⛽,🌍,🏔️,🏖️,🏠,⛩️,🗽,🌧️," \
	+ "🐿️,🪱,🌕,☀️,💧,🔥,☂️"


var all_emojis: Array[String] = []
var pool: Array[String] = []
var queue: Array[EmojiData] = []
var selected: Array[String] = []
var combo: PackedStringArray
var health: int
var index: int
var score: int
var score_total: int


func _ready() -> void:
	generate_queue()
	
	for emoji in EMOJIS.split(","):
		all_emojis.append(emoji)
	
	start_game()


func start_game() -> void:
	combo = queue.front().combo.split(",")
	all_emojis.shuffle()
	index = 0
	generate_pool()
	selected.resize(combo.size())
	selected.fill("")
	health = MAX_HEALTH


func restart() -> void:
	score = 0
	generate_queue()
	start_game()


func end_game() -> void:
	Game.score += 1
	queue.pop_front()


func generate_queue() -> void:
	for file_name in DirAccess.get_files_at(EMOJI_PATH):
		var data := load(EMOJI_PATH + file_name) as EmojiData
		if data == null:
			continue
		queue.append(data)
	
	queue.shuffle()
	queue.sort_custom(func (a: EmojiData, b: EmojiData): return a.combo.count(",") < b.combo.count(","))
	score_total = queue.size()


func generate_pool() -> void:
	pool.clear()
	
	for emoji in combo:
		pool.append(emoji)
	
	while pool.size() < POOL_SIZE:
		var emoji := get_next_emoji()
		if not emoji in pool:
			pool.append(emoji)
	
	pool.shuffle()


func get_next_emoji() -> String:
	index = (index + 1) % all_emojis.size()
	return all_emojis[index]


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
		if emoji == "" or not combo.has(emoji):
			return false
	return true

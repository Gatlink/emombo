extends Node


const GRID_SIZE := 16
const EMOJIS := "☠️,🤖,🐕,🐈,🐅,🐎,🦏,🐄,🐖,🐑,🐪,🦘,🦥,🦨,🐘,🐀,🐇," \
	+ "🦫,🦎,🐊,🐢,🐍,🦦,🐬,🦭,🐋,🐟,🦀,🦆,🐓,🦩,🦉,🐧,🦇,🐌,🐛,🦟," \
	+ "🦗,🐜,🪳,🐝,🐞,🦴,🦷,🧠,🫀,🫅,👮,🕵️,🧑‍⚕️,🧑‍🚀,💪,👃,🎈,🧨,🎄," \
	+ "🎞️,🎪,🎨,🧵,🛒,👓,🦺,🧦,👑,🎩,⚽,🏀,🏈,🎳,🎯,🥋,🏆,🕹️,🎲,🪩," \
	+ "♟️,🎤,🎷,🎸,🗝️,🧬,💊,🔬,🧪,🩸,🛡️,💡,🖌️,⌛,🍿,🧀,🥩,🫖,🍫,🧊," \
	+ "🍅,🍄,🥕,🌳,🚗,🛹,🛼,🚲,✈️,🚀,🛸,🛳️,⛽,🌍,🏔️,🏖️,🏠,⛩️,🗽,🌧️," \
	+ "🐿️,🪱,🌕,☀️,💧,🔥,☂️"


@export var to_find: Array[EmojiData]


var deck: Array[String] = []
var grid: Array[String]
var targets: Array[EmojiData] = []
var current_target: EmojiData


func _ready() -> void:
	fill_grid()
	current_target = get_next_target()


func fill_grid() -> void:
	grid = []
	for i in GRID_SIZE:
		grid.append(draw_emoji())


func draw_emoji() -> String:
	if deck.is_empty():
		shuffle_deck()
	
	return deck.pop_front()


func shuffle_deck() -> void:
	for emoji in EMOJIS.split(","):
		deck.append(emoji)
	deck.shuffle()


func shuffle_targets(combo_count: int) -> void:
	targets.clear()
	for target in to_find:
		var count := target.combo.count(",")
		if count == combo_count:
			targets.append(target)
	targets.shuffle()


func get_next_target() -> EmojiData:
	if targets.is_empty():
		shuffle_targets(2)
	return targets.pop_front()

extends Node


const GRID_SIZE := 16
const EMOJIS := "☠️,🤖,🐕,🐈,🐅,🐎,🦏,🐄,🐖,🐑,🐪,🦘,🦥,🦨,🐘,🐀,🐇," \
	+ "🦫,🦎,🐊,🐢,🐍,🦦,🐬,🦭,🐋,🐟,🦀,🦆,🐓,🦩,🦉,🐧,🦇,🐌,🐛,🦟," \
	+ "🦗,🐜,🪳,🐝,🐞,🦴,🦷,🧠,🫀,🫅,👮,🕵️,🧑‍⚕️,🧑‍🚀,💪,👃,🎈,🧨,🎄," \
	+ "🎞️,🎪,🎨,🧵,🛒,👓,🦺,🧦,👑,🎩,⚽,🏀,🏈,🎳,🎯,🥋,🏆,🕹️,🎲,🪩," \
	+ "♟️,🎤,🎷,🎸,🗝️,🧬,💊,🔬,🧪,🩸,🛡️,💡,🖌️,⌛,🍿,🧀,🥩,🫖,🍫,🧊," \
	+ "🍅,🍄,🥕,🌳,🚗,🛹,🛼,🚲,✈️,🚀,🛸,🛳️,⛽,🌍,🏔️,🏖️,🏠,⛩️,🗽,🌧️," \
	+ "🐿️,🪱,🌕,☀️,💧,🔥,☂️"


var deck: Array[String] = []
var grid: Array[String]


func _ready() -> void:
	fill_grid()


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

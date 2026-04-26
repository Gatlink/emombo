extends GridContainer


const TILE := preload("uid://re88klqry5km")


func _ready() -> void:
	refresh_grid()


func refresh_grid() -> void:
	for child in get_children():
		child.queue_free()
	
	for emoji in GameTuto.grid:
		var tile := TILE.instantiate() as Button
		tile.text = emoji
		add_child(tile)

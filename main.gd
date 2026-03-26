extends HBoxContainer


const EMOJI_SLOT := preload("uid://b3gq0sxauhq2t")


@onready var to_find: Label = $PanelContainer/VBoxContainer/ToFind
@onready var hint_label: Label = $PanelContainer/VBoxContainer/HintLabel
@onready var grid: GridContainer = $PanelContainer/VBoxContainer/Grid
@onready var combo: HBoxContainer = $PanelContainer/VBoxContainer/Combo
@onready var life_bar: HBoxContainer = $PanelContainer/VBoxContainer/LifeBar

@onready var shade: PanelContainer = $PanelContainer/Shade

@onready var win_panel: PanelContainer = $PanelContainer/Shade/CenterContainer/WinPanel
@onready var win_emoji: Label = $PanelContainer/Shade/CenterContainer/WinPanel/VBoxContainer/Emoji
@onready var win_score_label: Label = $PanelContainer/Shade/CenterContainer/WinPanel/VBoxContainer/ScoreLabel

@onready var success_panel: PanelContainer = $PanelContainer/Shade/CenterContainer/SuccessPanel
@onready var success_score_label: Label = $PanelContainer/Shade/CenterContainer/SuccessPanel/VBoxContainer/ScoreLabel


func _ready() -> void:
	for i in Game.POOL_SIZE:
		add_slot(grid)
	
	for i in Game.MAX_SELECTED_COUNT:
		add_slot(combo)
	
	on_new_game()


func _on_validate_button_pressed() -> void:
	if Game.is_selection_valid():
		Game.end_game()
		
		if Game.queue.is_empty():
			show_success_panel()
		else:
			show_win_panel()
	else:
		Game.health -= 1
		update_health()


func _on_win_button_pressed() -> void:
	shade.hide()
	win_panel.hide()
	Game.start_game()
	on_new_game()


func _on_success_button_pressed() -> void:
	shade.hide()
	success_panel.hide()
	Game.restart()
	on_new_game()


func _on_slot_pressed() -> void:
	update_grid()
	update_combo()


func add_slot(parent: Control) -> void:
	var instance := EMOJI_SLOT.instantiate() as EmojiSlot
	parent.add_child(instance)
	instance.pressed.connect(_on_slot_pressed)


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
		slot.text = Game.pool[i]
		slot.disabled = Game.selected.has(Game.pool[i])


func update_combo() -> void:
	for i in Game.MAX_SELECTED_COUNT:
		var slot := combo.get_child(i) as EmojiSlot
		if i < Game.selected.size():
			slot.text = Game.selected[i]
			slot.show()
			slot.disabled = Game.selected[i].is_empty()
		else:
			slot.hide()


func update_health() -> void:
	for i in Game.MAX_HEALTH:
		var heart := life_bar.get_child(i) as Label
		heart.text = "❤️" if i < Game.health else "🖤"


func show_win_panel() -> void:
	win_emoji.text = to_find.text
	win_score_label.text = "Score : %d points" % Game.score
	win_panel.show()
	shade.show()


func show_success_panel() -> void:
	success_score_label.text = "Score total : %d/%d" % [Game.score, Game.score_total]
	success_panel.show()
	shade.show()

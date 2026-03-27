extends HBoxContainer


const EMOJI_SLOT := preload("uid://b3gq0sxauhq2t")
const VALIDATION_TIME := 0.5


@onready var to_find: Label = $PanelContainer/VBoxContainer/ToFind
@onready var hint_label: Label = $PanelContainer/VBoxContainer/HintLabel
@onready var grid: GridContainer = $PanelContainer/VBoxContainer/Grid
@onready var combo: HBoxContainer = $PanelContainer/VBoxContainer/Combo
@onready var life_bar: HBoxContainer = $PanelContainer/VBoxContainer/LifeBar
@onready var validate_button: Button = $PanelContainer/VBoxContainer/ValidateButton
@onready var win_particle: CPUParticles2D = $WinParticle

@onready var shade: PanelContainer = $PanelContainer/Shade

@onready var win_panel: PanelContainer = $PanelContainer/Shade/CenterContainer/WinPanel
@onready var win_emoji: Label = $PanelContainer/Shade/CenterContainer/WinPanel/VBoxContainer/Emoji
@onready var win_score_label: Label = $PanelContainer/Shade/CenterContainer/WinPanel/VBoxContainer/ScoreLabel

@onready var success_panel: PanelContainer = $PanelContainer/Shade/CenterContainer/SuccessPanel
@onready var success_score_label: Label = $PanelContainer/Shade/CenterContainer/SuccessPanel/VBoxContainer/ScoreLabel

@onready var failure_panel: PanelContainer = $PanelContainer/Shade/CenterContainer/FailurePanel
@onready var failure_score_label: Label = $PanelContainer/Shade/CenterContainer/FailurePanel/VBoxContainer/ScoreLabel


var combo_slots: Array[EmojiSlot] = []


func _ready() -> void:
	for i in Game.POOL_SIZE:
		add_slot(grid)
	
	for i in Game.MAX_SELECTED_COUNT:
		add_slot(combo)
	
	for child in combo.get_children():
		var slot := child as EmojiSlot
		if slot != null:
			combo_slots.append(slot)
	
	on_new_game()


func _on_validate_button_pressed() -> void:
	var tween := create_tween()
	for i in Game.combo.size():
		if Game.combo.has(Game.selected[i]):
			tween.tween_callback(combo_slots[i].right)
		else:
			tween.tween_callback(combo_slots[i].wrong)
		tween.tween_interval(VALIDATION_TIME)
	
	tween.tween_callback(check_combo)


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


func _on_failure_button_pressed() -> void:
	shade.hide()
	failure_panel.hide()
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
	
	for slot in combo_slots:
		slot.reset()


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
	
	validate_button.disabled = Game.selected.count("") > 0


func update_health() -> void:
	for i in Game.MAX_HEALTH:
		var heart := life_bar.get_child(i) as Label
		heart.text = "❤️" if i < Game.health else "🖤"


func check_combo() -> void:
	if Game.is_selection_valid():
		win_particle.emitting = true
		Game.end_game()
		
		if Game.queue.is_empty():
			show_success_panel()
		else:
			show_win_panel()
	else:
		Game.health -= 1
		update_health()
		
		if Game.health <= 0:
			show_failure_panel()
		else:
			for slot in combo_slots:
				slot.reset()


func show_win_panel() -> void:
	win_emoji.text = to_find.text
	win_score_label.text = "Score : %d point%s" % [Game.score, "s" if Game.score > 1 else ""]
	win_panel.show()
	shade.show()


func show_success_panel() -> void:
	success_score_label.text = "Score total : %d/%d" % [Game.score, Game.score_total]
	success_panel.show()
	shade.show()


func show_failure_panel() -> void:
	failure_score_label.text = "Score final : %d point%s" % [Game.score, "s" if Game.score > 1 else ""]
	failure_panel.show()
	shade.show()

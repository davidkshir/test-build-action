extends Control

@export var results_manager: GameResultsManager

@onready var results_list: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ResultsList


func _ready() -> void:
	if results_manager == null:
		push_warning("RecentGames: No GameResultsManager assigned.")
		return

	results_manager.results_updated.connect(update_history)
	update_history()


func update_history() -> void:
	# Clear previously displayed results.
	for child in results_list.get_children():
		child.queue_free()

	# Add up to three recent games.
	for record in results_manager.get_recent_results():
		var panel = PanelContainer.new()
		var label = Label.new()

		label.text = "Player %s Victory\nPlayer %s Loss" % [
			str(record.winner_id),
			str(record.loser_id),
		]

		label.add_theme_font_size_override("font_size", 20)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		panel.add_child(label)
		results_list.add_child(panel)

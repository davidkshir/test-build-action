extends CenterContainer


func _on_start_pressed() -> void:
	for player in RootScene.instance.lobby_manager.players:
		player.health.health = 3

	RootScene.instance.network_manager.start_game()


func _on_quit_pressed() -> void:
	get_tree().quit()

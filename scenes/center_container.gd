extends CenterContainer


func _on_start_pressed() -> void:
	RootScene.instance.network_manager.request_start()


func _on_quit_pressed() -> void:
	get_tree().quit()

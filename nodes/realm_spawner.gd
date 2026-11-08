extends Node

@export var client_scene: PackedScene
@export var server_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func spawn_realm() -> void:
	if multiplayer.is_server():
		var instance = server_scene.instantiate()
		add_child(instance)

	else:
		var instance = client_scene.instantiate()
		add_child(instance)

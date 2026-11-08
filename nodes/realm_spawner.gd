extends Node

@export var client_scene: PackedScene

@export var server_scene: PackedScene


func _ready() -> void:
	setup_multiplayer_scene.call_deferred()


func setup_multiplayer_scene() -> void:
	var packed_scene = server_scene if multiplayer.is_server() else client_scene

	if packed_scene:
		var instance = packed_scene.instantiate()

		replace_by(instance)

class_name RootScene
extends Node

static var instance: RootScene:
	get:
		var scene_tree = Engine.get_main_loop() as SceneTree

		return scene_tree.current_scene

@onready var content_scene: Node = %ContentScene

@onready var lobby_manager: LobbyManager = %LobbyManager

@onready var network_manager: NetworkManager = %NetworkManager


func _ready() -> void:
	network_manager.manager_ready()


func transition_to(scene_path: String) -> void:
	ResourceLoader.load_threaded_request(scene_path)

	for child in content_scene.get_children():
		child.queue_free()

	var status = ResourceLoader.load_threaded_get_status(scene_path)

	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame

		status = ResourceLoader.load_threaded_get_status(scene_path)

	if status != ResourceLoader.THREAD_LOAD_LOADED:
		push_error(
			"bad argument #0 to 'RootScene.transition_to' (scene '%s' failed to load)" % scene_path,
		)

		return

	var target_scene = ResourceLoader.load_threaded_get(scene_path) as PackedScene

	if not target_scene:
		push_error(
			"bad argument #0 to 'RootScene.transition_to' (scene '%s' was not a 'PackedScene')"
			% scene_path,
		)

		return

	content_scene.add_child(target_scene.instantiate())

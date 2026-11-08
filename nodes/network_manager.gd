class_name NetworkManager
extends Node

# CHANGE TO SERVER'S TAILSCALE IP BEFORE USE
const SERVER_IP_ADDRESS: String = "100.105.71.113"

const SERVER_PORT: int = 27015
const MAX_PLAYERS: int = 2


# Called when the node enters the scene tree for the first time.
func manager_ready() -> void:
	var peer = ENetMultiplayerPeer.new()

	# Connect client
	if OS.has_feature("mobile"):
		var result = peer.create_client(SERVER_IP_ADDRESS, SERVER_PORT)

		if result != OK:
			push_error("Client failed to start " + error_string(result))
			return

		multiplayer.multiplayer_peer = peer

	# Start server
	else:
		var result = peer.create_server(SERVER_PORT, MAX_PLAYERS)

		if result == OK:
			print("Server listening on port " + str(SERVER_PORT))
		else:
			push_error("Server failed to start " + error_string(result))
			return

		RootScene.instance.transition_to("res://scenes/lobby_scene.tscn")

		# Creates signal for clients connecting
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)

		multiplayer.multiplayer_peer = peer


func start_game() -> void:
	if not multiplayer.is_server():
		print("NOT THE SERVER")
		return

	_load_battlefield.rpc()
	RootScene.instance.transition_to("res://scenes/battlefield_scene.tscn")


func _on_peer_connected(id: int) -> void:
	RootScene.instance.lobby_manager.add_player(id)
	print("Player client id '%s' id" % id)


func _on_peer_disconnected(id: int) -> void:
	if not RootScene.instance.lobby_manager.has_player(id):
		print("Non-player client id '%s' disconnected" % id)
		return

	RootScene.instance.lobby_manager.remove_player(id)
	print("Player client id '%s' connected" % id)


@rpc("authority", "call_remote", "reliable")
func _load_battlefield() -> void:
	RootScene.instance.transition_to("res://scenes/battlefield_scene.tscn")

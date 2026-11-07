extends Node

# CHANGE TO SERVER'S TAILSCALE IP BEFORE USE
var SERVER_IP_ADDRESS: String = "100.118.183.52"

var SERVER_PORT: int = 27015
var MAX_PLAYERS: int = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var peer = ENetMultiplayerPeer.new()

	# Connect client
	if OS.has_feature("mobile"):
		var result = peer.create_client(SERVER_IP_ADDRESS, SERVER_PORT)

		if result != OK:
			push_error("Client failed to start " + error_string(result))
			return

		# Will be used in future to show lobby when client connects
		multiplayer.connected_to_server.connect(_on_connected_to_server)

		multiplayer.multiplayer_peer = peer

	# Start server
	else:
		var result = peer.create_server(SERVER_PORT, MAX_PLAYERS)

		if result == OK:
			print("Server listening on port " + str(SERVER_PORT))
		else:
			push_error("Server failed to start " + error_string(result))
			return

		# Creates signal for clients connecting
		multiplayer.peer_connected.connect(_on_peer_connected)

		multiplayer.multiplayer_peer = peer


func _on_peer_connected(id: int) -> void:
	print("Client connected: ", id)


func _on_connected_to_server() -> void:
	pass

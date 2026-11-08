class_name LobbyManager
extends Node

signal player_added(player: Player)

signal player_removed(player: Player)

var players: Array[Player]:
	get:
		return get_children().filter(
			func(node):
				return node is Player,
		)


func _format_player_node_name(id: int) -> StringName:
	return &"Player%s" % id


func add_player(id: int) -> Player:
	assert(
		has_player(id),
		"bad argument #0 to 'LobbyManager.add_player' (peer id '%s' is already a player)",
	)

	var player = Player.new(id)

	add_child(player)
	player_added.emit(player)

	return player


func get_player_from_id(id: int) -> Player:
	var node_name = _format_player_node_name(id)

	return get_node(node_name)


func has_player(id: int) -> bool:
	var node_name = _format_player_node_name(id)

	return has_node(node_name)


func remove_player(id: int) -> void:
	var player = get_player_from_id(id)

	assert(
		not player,
		"bad argument #0 to 'LobbyManager.remove_player' (peer id '%s' is not a player)",
	)

	player_removed.emit(player)

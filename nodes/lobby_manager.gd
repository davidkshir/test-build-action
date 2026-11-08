class_name LobbyManager
extends Node

const PLAYER_SCENE = preload("res://nodes/player.tscn")

signal player_added(player: Player)

signal player_removed(player: Player)

var players: Array[Player]:
	get:
		var list: Array[Player] = []

		for child in get_children():
			if child is Player:
				list.append(child)

		return list


func _format_player_node_name(id: int) -> String:
	return "Player%s" % id


func add_player(id: int) -> Player:
	assert(
		not has_player(id),
		"bad argument #0 to 'LobbyManager.add_player' (peer id '%s' is already a player)" % id,
	)

	var player: Player = PLAYER_SCENE.instantiate()

	player.id = id
	player.name = _format_player_node_name(id)

	player.set_multiplayer_authority(id)

	add_child(player)
	player_added.emit(player)

	return player


func get_player_from_id(id: int) -> Player:
	var node_name = _format_player_node_name(id)

	return get_node_or_null(node_name) as Player


func has_player(id: int) -> bool:
	var node_name = _format_player_node_name(id)

	return has_node(node_name)


func remove_player(id: int) -> void:
	var player = get_player_from_id(id)

	assert(
		player != null,
		"bad argument #0 to 'LobbyManager.remove_player' (peer id '%s' is not a player)" % id,
	)

	player_removed.emit(player)
	player.queue_free()

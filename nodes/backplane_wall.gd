class_name BackplaneWall
extends Node3D

var _player: Player = null

var player: Player:
	get:
		return _player
	set(value):
		var old_player = _player
		_player = value

		_player_changed(old_player, value)


func _player_changed(_old_player: Player, _new_player: Player) -> void:
	pass

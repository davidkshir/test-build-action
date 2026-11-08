class_name Paddle
extends Node3D

var _player: Player = null

var player: Player:
	get:
		return _player
	set(value):
		var old_player = _player
		_player = value

		_player_changed(old_player, value)

var ar_position: Vector2

@onready var animatable_body_3d: AnimatableBody3D = %AnimatableBody3D

@onready var camera_3d: Camera3D = %Camera3D


func _player_changed(_old_player: Player, new_player: Player) -> void:
	if multiplayer.is_server():
		return

	var id = multiplayer.get_unique_id()
	var player = RootScene.instance.lobby_manager.get_player_from_id(id)

	camera_3d.current = player == new_player


func _physics_process(_delta: float) -> void:
	pass # do movement w/ `animatable_body_3d`

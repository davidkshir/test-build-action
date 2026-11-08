class_name Battlefield
extends Node3D

@onready var backplane_wall_1: BackplaneWall = $BackplaneWall1

@onready var backplane_wall_2: BackplaneWall = $BackplaneWall2

@onready var paddle_1: Paddle = $Paddle1

@onready var paddle_2: Paddle = $Paddle2


func _ready() -> void:
	if not multiplayer.is_server():
		return

	RootScene.instance.lobby_manager.player_added.connect(_player_added)
	RootScene.instance.lobby_manager.player_removed.connect(_player_removed)

	for player in RootScene.instance.lobby_manager.players:
		_player_added(player)


func _exit_tree() -> void:
	if not multiplayer.is_server():
		return

	RootScene.instance.lobby_manager.player_added.disconnect(_player_added)
	RootScene.instance.lobby_manager.player_removed.disconnect(_player_removed)


func _get_available_backplane_wall() -> BackplaneWall:
	if backplane_wall_1.player == null:
		return backplane_wall_1

	if backplane_wall_2.player == null:
		return backplane_wall_2

	return null


func _get_matching_backplane_wall(player: Player) -> BackplaneWall:
	if backplane_wall_1.player == player:
		return backplane_wall_1

	if backplane_wall_2.player == player:
		return backplane_wall_2

	return null


func _get_available_paddle() -> Paddle:
	if paddle_1.player == null:
		return paddle_1

	if paddle_2.player == null:
		return paddle_2

	return null


func _get_matching_paddle(player: Player) -> Paddle:
	if paddle_1.player == player:
		return paddle_1

	if paddle_2.player == player:
		return paddle_2

	return null


func _player_added(player: Player) -> void:
	var backplane_wall = _get_available_backplane_wall()
	var paddle = _get_available_paddle()

	assert(
		backplane_wall != null,
		"bad dispatch to 'Battlefield._player_added' (no available 'BackplaneWall')",
	)

	assert(paddle != null, "bad dispatch to 'Battlefield._player_added' (no available 'Paddle')")

	backplane_wall.player = player
	paddle.player = player


func _player_removed(player: Player) -> void:
	var backplane_wall = _get_matching_backplane_wall(player)
	var paddle = _get_matching_paddle(player)

	assert(
		backplane_wall != null,
		"bad dispatch to 'Battlefield._player_removed' (no assigned 'BackplaneWall')",
	)

	assert(paddle != null, "bad dispatch to 'Battlefield._player_removed' (no assigned 'Paddle')")

	backplane_wall.player = null
	paddle.player = null

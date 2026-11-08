class_name Paddle
extends AnimatableBody3D

const WALL_HALF_EXTENTS: Vector2 = Vector2(1.0, 1.0) # 2m x 2m backplane wall centered at half

var player: Player:
	get:
		return _player
	set(value):
		var old_player = _player
		_player = value

		_player_changed(old_player, value)

var ar_position: Vector2

var _player_id: int = -1

var _player: Player = null

@onready var camera_3d: Camera3D = %Camera3D

@onready var _initial_basis: Basis = transform.basis

@onready var _initial_position: Vector3 = position


func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server() or player == null:
		return

	var tracking_delta = player.tracking_delta.tracking_delta

	var local_x = clampf(
		tracking_delta.x * WALL_HALF_EXTENTS.x,
		-WALL_HALF_EXTENTS.x,
		WALL_HALF_EXTENTS.x,
	) * 5

	var local_y = clampf(
		tracking_delta.y * WALL_HALF_EXTENTS.y,
		-WALL_HALF_EXTENTS.y,
		WALL_HALF_EXTENTS.y,
	) * 5

	var local_right: Vector3 = _initial_basis.x.normalized()
	var local_up: Vector3 = _initial_basis.y.normalized()

	position = _initial_position + (local_right * local_x) + (local_up * local_y)


@rpc("authority", "call_local", "reliable")
func _sync_player_id(id: int) -> void:
	camera_3d.current = id == multiplayer.get_unique_id()


func _player_changed(_old_player: Player, new_player: Player) -> void:
	if not multiplayer.is_server():
		return

	_sync_player_id.rpc(new_player.id)

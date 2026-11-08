class_name PlayerInput
extends Node

@export var motion_scale: float = 1.0

var current_anchor: ARAnchorTracker = null

var initial_anchor_transform: Transform3D = Transform3D.IDENTITY

var is_calibrated: bool = false

@onready var ar_view: ARView = $ARView

@onready var player: Player = get_parent()


func _ready() -> void:
	ar_view.virtual_scene.render_target_update_mode = SubViewport.UPDATE_DISABLED

	if multiplayer.is_server():
		return

	if OS.has_feature("ios"):
		ar_view.backend = ARView.Backend.ARKIT
	elif OS.has_feature("android"):
		ar_view.backend = ARView.Backend.ARCORE

	ar_view.packet_applied.connect(_on_first_packet, CONNECT_ONE_SHOT)


func _process(_delta: float) -> void:
	if multiplayer.is_server() or not is_calibrated:
		return

	var anchor_transform = initial_anchor_transform

	if current_anchor and current_anchor.has_tracking_data:
		var xr_pose: XRPose = current_anchor.get_pose("default")

		if xr_pose:
			anchor_transform = xr_pose.transform

	var camera_position = ar_view.camera.global_position
	var local_displacement = anchor_transform.affine_inverse() * camera_position

	var tracking_delta = Vector2(local_displacement.x, local_displacement.y) * motion_scale

	send_input_delta.rpc_id(1, tracking_delta)


func calibrate() -> void:
	var camera_transform: Transform3D = ar_view.camera.global_transform

	initial_anchor_transform = camera_transform

	if current_anchor:
		ar_view.remove_anchor(current_anchor)

	current_anchor = ar_view.create_anchor(camera_transform)
	is_calibrated = true


@rpc("any_peer", "call_local", "unreliable")
func send_input_delta(tracking_delta: Vector2) -> void:
	if not multiplayer.is_server():
		return

	player.tracking_delta.tracking_delta = tracking_delta


func _on_first_packet(_packet: ARFramePacket) -> void:
	calibrate()

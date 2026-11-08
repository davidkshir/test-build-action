extends Node

@onready var ar_view = $ARView
@onready var player: Player = get_parent()
const SERVER_ID: int = 1

var ar_position: Vector2 = Vector2.ZERO

var paddle: Paddle


func _ready() -> void:
	if multiplayer.is_server():
		_ready_server()
		return
	_ready_client()


func _ready_client() -> void:
	if OS.has_feature("ios"):
		ar_view.Backend = ARView.Backend.ARKIT
	else:
		ar_view.Backend = ARView.Backend.ARCORE

	paddle.position.x = ar_view.applied_packet.camera.x
	paddle.position.y = ar_view.applied_packet.camera.y

	ar_position = Vector2(paddle.position.x, paddle.position.y)
	_set_coordinates.rpc(ar_position)


func _ready_server() -> void:
	var battlefield_scene: Node3D = RootScene.instance.get_node("ContentScene").get_child(0)
	paddle = battlefield_scene.get_node("Paddle1")

	if not paddle:
		paddle = battlefield_scene.get_node("Paddle2")

	paddle.player = player


func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		return

	if ar_view.applied_packet == null:
		return


@rpc("any_peer", "unreliable")
func _set_coordinates(position: Vector2) -> void:
	paddle.ar_position = position

extends Node

@onready var ar_view = $ARView
@onready var battlefield = $battlefield
@onready var player: Player = get_parent()
const SERVER_ID: int = 1

var ar_position: Vector2 = Vector2.ZERO

var paddle: Paddle


func _ready() -> void:
	if multiplayer.is_server():
		return

	if OS.has_feature("ios"):
		ar_view.Backend.ARKIT
	else:
		ar_view.Backend.ARCORE

	var battlefield_scene: Node3D = RootScene.instance.get_node("ContentScene").get_child(0)
	paddle = battlefield_scene.get_node("Paddle1")

	if not paddle:
		paddle = battlefield_scene.get_node("Paddle2")
		battlefield.get_node("Backplane2").player(player)

	paddle.player = player
	battlefield.get_node("Backplane1").player(player)


func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		return

	if ar_view.applied_packet == null:
		return


@rpc("any_peer", "unreliable")
func _set_coordinates(position: Vector2) -> void:
	paddle.ar_position = position

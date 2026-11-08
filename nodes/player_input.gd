class_name PlayerInput
extends Node

const SERVER_ID: int = 1

var ar_position: Vector2 = Vector2.ZERO

var backplane_wall: BackplaneWall

var paddle: Paddle

@onready var ar_view = $ARView

@onready var battlefield: Battlefield = RootScene.instance.content_scene.get_child(0).get_node(
	"Battlefield"
)

@onready var player: Player = get_parent()


func _ready() -> void:
	if multiplayer.is_server():
		return

	if OS.has_feature("ios"):
		ar_view.backend = ARView.Backend.ARKIT
	else:
		ar_view.backend = ARView.Backend.ARCORE

	backplane_wall = battlefield.backplane_wall_2 \
			if battlefield.backplane_wall_1.player else battlefield.backplane_wall_1

	paddle = battlefield.paddle_2 \
			if battlefield.paddle_1.player else battlefield.paddle_1

	backplane_wall.player = player
	paddle.player = player


func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		return

	if ar_view.applied_packet == null:
		return


@rpc("any_peer", "unreliable")
func _set_coordinates(position: Vector2) -> void:
	paddle.ar_position = position

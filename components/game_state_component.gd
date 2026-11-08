class_name GameStateComponent
extends ObservableComponent

enum GameState {
	STATE_PLAYING,

	STATE_ENDED,
}

@export() var game_state: GameState:
	get:
		return _value
	set(value):
		_value = value

		if value == GameState.STATE_ENDED:
			RootScene.instance.transition_to("res://scenes/lobby_scene.tscn")


func _init(initial_value: GameState = GameState.STATE_PLAYING) -> void:
	super(initial_value)


func _ready() -> void:
	RootScene.instance.lobby_manager.player_added.connect(_player_added)
	RootScene.instance.lobby_manager.player_removed.connect(_player_removed)


func _exit_tree() -> void:
	RootScene.instance.lobby_manager.player_added.disconnect(_player_added)
	RootScene.instance.lobby_manager.player_removed.disconnect(_player_removed)


func _player_added(player: Player) -> void:
	var callable = _player_health_changed.bind(player)

	player.health.changed.connect(callable)


func _player_removed(player: Player) -> void:
	var callable = _player_health_changed.bind(player)

	if player.health.changed.is_connected(callable):
		player.health.changed.disconnect(callable)


func _player_health_changed(old_health: int, new_health: int, _player: Player) -> void:
	if old_health > 0 and new_health < 1:
		game_state = GameState.STATE_ENDED

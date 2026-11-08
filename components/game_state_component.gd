class_name GameStateComponent
extends ObservableComponent

enum GameState {
	STATE_NONE,

	STATE_STARTED,

	STATE_COUNTDOWN,

	STATE_PRE_ROUND,

	STATE_POST_ROUND,

	STATE_ENDED,
}

@export() var game_state: GameState:
	get:
		return _value
	set(value):
		_value = value


func _init(initial_value: GameState = GameState.STATE_NONE) -> void:
	super(initial_value)

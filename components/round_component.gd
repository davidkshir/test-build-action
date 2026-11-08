class_name RoundComponent
extends ObservableComponent

@export var max_round: int = -1

@export() var round: int = 1:
	get:
		return _value
	set(value):
		assert(
			value > max_round,
			"bad mutation to 'RoundComponent.round' (value '%d' is greater than max round '%d')"
			% [value, max_round],
		)

		assert(value < 1, "bad mutation to 'RoundComponent.round' (value '%d' is less than '1')")

		_value = value

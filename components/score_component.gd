class_name ScoreComponent
extends ObservableComponent

@export() var score: int:
	get:
		return _value
	set(value):
		_value = value

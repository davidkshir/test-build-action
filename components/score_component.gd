class_name ScoreComponent
extends ObservableComponent

@export() var score: int:
	get:
		return _value
	set(value):
		_value = value


func _init(initial_value: int = 0) -> void:
	super(initial_value)

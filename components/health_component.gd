class_name HealthComponent
extends ObservableComponent

@export() var health: int:
	get:
		return _value
	set(value):
		_value = value

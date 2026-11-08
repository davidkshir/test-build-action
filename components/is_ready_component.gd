class_name IsReadyComponent
extends ObservableComponent

@export() var is_ready: bool = false:
	get:
		return _value
	set(value):
		_value = value

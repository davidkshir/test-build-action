class_name HealthComponent
extends ObservableComponent

@export() var health: int:
	get:
		return _value
	set(value):
		_value = value


func _init(initial_value: int = 3) -> void:
	super(initial_value)

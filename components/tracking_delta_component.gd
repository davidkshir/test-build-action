class_name TrackingDeltaComponent
extends ObservableComponent

@export var tracking_delta: Vector2:
	get:
		return _value
	set(value):
		_value = value


func _init(initial_value: Vector2 = Vector2.ZERO) -> void:
	super(initial_value)

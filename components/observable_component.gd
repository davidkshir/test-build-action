class_name ObservableComponent
extends Node

signal changed(old_value: Variant, new_value: Variant)

var _initial_value: Variant

var _value: Variant:
	set(new_value):
		if _value != new_value:
			var old_value = _value
			_value = new_value

			changed.emit(old_value, new_value)


func _init(initial_value: Variant = null) -> void:
	_initial_value = initial_value
	_value = initial_value


func reset() -> void:
	_value = _initial_value

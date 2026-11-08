extends Node3D

@export var rotation_speed: float = 15.0

@onready var camera: Camera3D = $"Orbit Cam"


func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed) * delta)

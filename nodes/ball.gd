class_name Ball
extends RigidBody3D

@export var speed: float = 1.0

@export var spin_strength: float = 4.0

@export var maximum_z_ratio: float = 0.90

@export var minimum_z_ratio: float = 0.70


func _ready() -> void:
	gravity_scale = 0.0

	var initial_z_direction: float = [-1.0, 1.0].pick_random()

	var initial_direction: Vector3 = Vector3(
		randf_range(-0.35, 0.35),
		randf_range(-0.15, 0.15),
		initial_z_direction,
	).normalized()

	linear_velocity = initial_direction * speed
	angular_velocity = _get_random_spin()


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.linear_velocity.is_zero_approx():
		return

	var current_direction: Vector3 = state.linear_velocity.normalized()
	var z_magnitude: float = absf(current_direction.z)

	if z_magnitude < minimum_z_ratio:
		current_direction.z = _get_non_zero_sign(current_direction.z) * minimum_z_ratio

		current_direction = current_direction.normalized()

	elif z_magnitude > maximum_z_ratio:
		current_direction.z = _get_non_zero_sign(current_direction.z) * maximum_z_ratio
		current_direction.x = _get_non_zero_sign(current_direction.x) * randf_range(0.35, 0.5)
		current_direction.y = randf_range(-0.15, 0.15)

		current_direction = current_direction.normalized()

		state.angular_velocity = _get_random_spin()

	state.linear_velocity = current_direction * speed


func _get_non_zero_sign(value: float) -> float:
	if is_zero_approx(value):
		return [-1.0, 1.0].pick_random()

	return signf(value)


func _get_random_spin() -> Vector3:
	return Vector3(
		\
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
	).normalized() * spin_strength

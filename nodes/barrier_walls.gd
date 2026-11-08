@tool
class_name BarrierWalls
extends StaticBody3D

@export var target_node: Node3D

@onready var roof_mesh_instance_3d: MeshInstance3D = %RoofMeshInstance3D

@onready var floor_mesh_instance_3d: MeshInstance3D = %FloorMeshInstance3D

@onready var right_mesh_instance_3d: MeshInstance3D = %RightMeshInstance3D

@onready var left_mesh_instance_3d: MeshInstance3D = %LeftMeshInstance3D


func _process(_delta: float) -> void:
	_apply_shimmer_origin(roof_mesh_instance_3d)
	_apply_shimmer_origin(floor_mesh_instance_3d)
	_apply_shimmer_origin(right_mesh_instance_3d)
	_apply_shimmer_origin(left_mesh_instance_3d)


func _apply_shimmer_origin(mesh_instance_3d: MeshInstance3D) -> void:
	if not mesh_instance_3d or not mesh_instance_3d.mesh:
		return

	if not is_instance_valid(target_node) or not target_node.is_inside_tree():
		return

	var shader_material = mesh_instance_3d.material_override as ShaderMaterial

	if not shader_material:
		return

	var local_position = mesh_instance_3d.to_local(target_node.global_position)
	var aabb = mesh_instance_3d.get_aabb()

	var closest_point = Vector3(
		clampf(local_position.x, aabb.position.x, aabb.end.x),
		clampf(local_position.y, aabb.position.y, aabb.end.y),
		clampf(local_position.z, aabb.position.z, aabb.end.z),
	)

	shader_material.set_shader_parameter("shimmer_origin", closest_point)

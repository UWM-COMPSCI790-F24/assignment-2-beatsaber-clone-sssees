extends Node3D
class_name LaserPointer

# Expects to be set up like so:
# LaserPointer
# - Cylinder/quad shape
# - Area3D
#   - CollisionShape3D

func PointTowards(pointPos: Vector3) -> void:
	var dist = global_position.distance_to(pointPos)
	scale.z = dist
	look_at(pointPos, get_viewport().get_camera_3d().get_global_transform().basis.y)

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("pussy!", area)

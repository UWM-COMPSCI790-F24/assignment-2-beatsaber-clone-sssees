extends Node3D
class_name LaserPointer
signal laser_entered_area(area: Area3D)

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
	if area.get_parent() is LaserPointer:
		return
	
	laser_entered_area.emit(area)

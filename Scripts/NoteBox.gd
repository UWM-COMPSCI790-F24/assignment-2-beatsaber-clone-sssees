extends Node3D
class_name NoteBox
enum NoteIdent {
	Netural = 0,
	Red,
	Blue
}
static var NoteIdentColors: Array[Color] = [Color(0.8, 0.8, 0.8, 1), Color(1, 0, 0, 1), Color(0, 0, 1, 1)]

@export var ident: NoteIdent

var killTimer: float = INF

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid($Vis):
		PaintIt($Vis)
	if is_instance_valid($Gibs):
		PaintIt($Gibs)
		
	#DoGibs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	killTimer -= delta
	if killTimer <= 0:
		queue_free()
		
func Push(vec: Vector3) -> void:
	#print("pushiny", vec)
	if is_instance_valid($Vis):
		$Vis.position += vec
		if $Vis.position.z > 8:
			queue_free()

func PaintIt(node: Node3D) -> void:
	if !is_instance_valid(node):
		return
	
	for child in node.get_children():
		if child is MeshInstance3D:
			# why can't we just have material instances like Unity. why.
			var mat = child.mesh.surface_get_material(0).duplicate()
			var det = mat.detail_albedo.duplicate()
			var gra = det.gradient.duplicate()
			mat.detail_albedo = det
			mat.detail_albedo.gradient = gra
			mat.detail_albedo.gradient.set_color(0, NoteIdentColors[ident])
			#child.mesh.surface_set_material(0, mat)
			child.material_override = mat
		elif child is GeometryInstance3D:
			#if !is_instance_valid(child.material_override):
			#	child.material_override = child.material.duplicate()
			child.material_override.albedo_color = NoteIdentColors[ident]
		PaintIt(child)

func DoGibs() -> void:
	if is_instance_valid($Vis):
		$Vis.set_process_mode(Node.PROCESS_MODE_DISABLED)
		$Vis.hide()
	if is_instance_valid($Gibs):
		$Gibs.position = $Vis.position
		$Gibs.set_process_mode(Node.PROCESS_MODE_INHERIT)
		$Gibs.show()
		
		for child in $Gibs.get_children():
			if child is RigidBody3D:
				var rb = child as RigidBody3D
				var randy = Vector3((randf()-0.5), (randf()-0.5), (randf()-0.5)) * 800
				
				rb.apply_central_impulse((-global_transform.basis.y.normalized() * 4) + (randy.normalized() * 2))
				rb.apply_torque(randy)
	
	killTimer = 4.0

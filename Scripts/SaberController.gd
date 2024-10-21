extends XRController3D
class_name SaberController

@export var saberType: NoteBox.NoteIdent
@export var laser: LaserPointer
@export var laserLength: float = 0.5
var laserVisible: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_instance_valid(laser):
		laser = $LaserPointer
	if !is_instance_valid(laser):
		printerr("Controller failed to get laser!")
	
	laser.laser_entered_area.connect(_on_laser_entered_area)
	laser.visible = laserVisible
	
	laser.SetColor(NoteBox.NoteIdentColors[saberType])

var buttonPressedLastFrame = false # ew, don't like this...
func _process(delta: float) -> void:
	laser.PointTowards(position - (transform.basis.z) * laserLength)
	
	if is_button_pressed("ax_button") && !buttonPressedLastFrame:
		laserVisible = !laserVisible
		laser.set_process_mode(Node.ProcessMode.PROCESS_MODE_INHERIT if laserVisible else Node.ProcessMode.PROCESS_MODE_DISABLED)
		laser.visible = laserVisible
	buttonPressedLastFrame = is_button_pressed("ax_button")

func _on_laser_entered_area(area: Area3D, strikeDir: Vector3) -> void:
	var possibleNode: Node3D = area.get_node(area.get_meta("NoteBox"))
	
	if possibleNode is not NoteBox:
		return
		
	var box = possibleNode as NoteBox
	#print("Note box hit! ", box)
	
	var matchesType = box.ident == saberType || box.ident == NoteBox.NoteIdent.Netural
	var matchesDirection = strikeDir.dot(-box.global_transform.basis.y.normalized()) > 0.6
	
	if matchesType && matchesDirection:
		box.DoGibs()
	
	

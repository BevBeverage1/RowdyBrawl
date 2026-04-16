@tool
class_name CameraPath
extends Path2D

@export var target_node: Node2D
@export var follow_smoothing_speed: float = 5
@export var section_smoothing_speed: float = 1

@onready var path_follow: PathFollow2D = %PathFollow
var camera: Camera2D

var is_section_active: bool

var _active_sections: Array[CameraPathSection]



func _init() -> void:
	child_entered_tree.connect(func(_n): update_configuration_warnings())
	child_exiting_tree.connect(func(_n): update_configuration_warnings())


func _ready():
	if Engine.is_editor_hint(): return
	
	# find camera in children
	camera = get_child(get_children().find_custom(func(node): return node is Camera2D))
	
	# parent camera to PathFollow
	if camera:
		if camera.get_parent():
			camera.get_parent().remove_child(camera)
		
		path_follow.add_child(camera)
		camera.position = Vector2.ZERO
	else:
		push_error("No child of type Camera2D")


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return 
	
	if is_section_active:
		set_section_position(_active_sections[-1])
	else:
		var offset := curve.get_closest_offset(target_node.global_position)
		path_follow.progress = offset
	
	
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if get_children().find_custom(func(node): return node is Camera2D) == -1:
		warnings.append("needs a child Camera2D node")
	
	return warnings
	
	
func entered_section(section: CameraPathSection):
	if not _active_sections.has(section):
		_active_sections.append(section)
		
		is_section_active = true
		camera.position_smoothing_speed = section_smoothing_speed



func exited_section(section: CameraPathSection):
	if _active_sections.has(section):
		_active_sections.remove_at(_active_sections.find(section))
	
	if _active_sections.is_empty():
		is_section_active = false
		camera.position_smoothing_speed = follow_smoothing_speed
	


func set_section_position(section: CameraPathSection):
	var offset := curve.get_closest_offset(to_local(section.global_position))
	path_follow.progress = offset


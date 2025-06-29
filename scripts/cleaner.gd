class_name Cleaner
extends CharacterBody3D
@onready var PIPE: MeshInstance3D = $pipe
@onready var PIPE_MARKER: Marker3D = $pipe_marker

var is_grab: bool = false
var target_node: Node3D

func _physics_process(delta: float) -> void:
	_grab()


func _grab():
	if is_grab: PIPE.global_position = target_node.global_position
	else: PIPE.global_position = PIPE_MARKER.global_position


func _on_pipe_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().is_in_group("hand"):
		is_grab = true
		target_node = area.get_parent_node_3d()

extends RigidBody3D
var target_node: Node3D
var IS_PICK: bool = false

func _physics_process(delta: float) -> void:
	if IS_PICK: global_position = target_node.global_position


func _on_object_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().is_in_group("hand"):
		if not IS_PICK:
			IS_PICK = true
			area.get_parent_node_3d().IS_PICK = IS_PICK
			target_node = area.get_parent_node_3d()
			

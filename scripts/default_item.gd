extends RigidBody3D
var IS_PICK: bool = false


func _on_object_area_entered(area: Area3D) -> void:
	_pick_object(area)


func _pick_object(area: Area3D) -> void:
	if area.get_parent_node_3d().is_in_group("hand"):
		if not IS_PICK:
			IS_PICK = true
			var hand = area.get_parent_node_3d()
			hand.pick_object(self)

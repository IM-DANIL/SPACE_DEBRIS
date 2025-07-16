extends RigidBody3D
var IS_DRAG: bool = false


func _on_object_area_entered(area: Area3D) -> void:
	_pick_object(area)


func _pick_object(area: Area3D) -> void:
	if area.get_parent_node_3d().is_in_group("hand"):
		if not IS_DRAG:
			
			IS_DRAG = true
			area.get_parent_node_3d().drag_object(self)


func drop_object(_hold_time: float, _direction: Vector3) -> void:
	linear_velocity = Vector3.ZERO
	if _hold_time < 2.0:
		apply_central_impulse(_direction * 5.0)
	else:
		apply_central_impulse(_direction * 10.0)

class_name Hand
extends CSGMesh3D
@export var HAND_POS: Marker3D

var IS_SQUEEZE: bool = false
@export var SPEED_HAND: float = 5.0

func _physics_process(delta: float) -> void:
	if HAND_POS: _hand_movement(delta)


func _hand_movement(delta: float) -> void:
	if not IS_SQUEEZE: global_position = lerp(global_position, HAND_POS.global_position, delta * SPEED_HAND)

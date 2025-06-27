class_name Hand
extends MeshInstance3D
var POS: Marker3D = null

var IS_PULL: bool = false
@export var IS_LEFT: bool = false
@export var SPEED_HAND: float = 5.0


func _ready() -> void:
	_check_markers()


func _physics_process(delta: float) -> void:
	if POS:
		_hand_move(delta)


func _hand_move(delta: float) -> void:
	if !IS_PULL:
		global_position = lerp(global_position, POS.global_position, delta * SPEED_HAND)


func _check_markers() -> void:
	if get_tree().has_group("hands_pos"):
		for marker in get_tree().get_nodes_in_group("hands_pos"):
			if marker.IS_LEFT and IS_LEFT: POS = marker
			elif !marker.IS_LEFT and !IS_LEFT: POS = marker

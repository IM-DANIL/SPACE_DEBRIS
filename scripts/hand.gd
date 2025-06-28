class_name Hand
extends MeshInstance3D
var POS: Marker3D = null
var PLAYER: CharacterBody3D = null

var IS_PULL: bool = false
@export var IS_LEFT: bool = false
@export var SPEED_HAND: float = 5.0


func _ready() -> void:
	_check_player()
	_check_markers()
	_check_hands()


func _physics_process(delta: float) -> void:
	if POS:
		_hand_move(delta)


func _hand_move(delta: float) -> void:
	if !IS_PULL:
		global_position = lerp(global_position, POS.global_position, delta * SPEED_HAND)


func _check_player() -> void:
	for player in get_parent().get_children():
		if player.is_in_group("player"):
			PLAYER = player


func _check_markers() -> void:
	if get_tree().has_group("hands_pos"):
		for marker in get_tree().get_nodes_in_group("hands_pos"):
			if not marker.IS_ASSIGNED:
				if marker.IS_LEFT and IS_LEFT: 
					POS = marker
					marker.IS_ASSIGNED = true
				elif !marker.IS_LEFT and !IS_LEFT: 
					POS = marker
					marker.IS_ASSIGNED = true


func _check_hands() -> void:
	if PLAYER:
		if IS_LEFT:
			if not PLAYER.LEFT_HAND["NODE"]: PLAYER.LEFT_HAND["NODE"] = self
		else:
			if not PLAYER.RIGHT_HAND["NODE"]: PLAYER.RIGHT_HAND["NODE"] = self

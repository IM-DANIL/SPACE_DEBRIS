class_name Garbage
extends RigidBody3D
var HAND: Hand

var IS_DRAG: bool = false

@export var HOLD_TIME: float = 5.0
@export var GARBAGE_IMPULSE_SCALE: float = 5.0
@export var PLAYER_IMPULSE_SCALE: float = 7.0

func _physics_process(delta: float) -> void:
	if IS_DRAG and HAND: _object_movement(delta)


func _object_movement(_delta: float) -> void:
	global_position = HAND.OBJECT_POS.global_position
	global_rotation = HAND.global_rotation


func drop_object(hold_time: float, dir: Vector3, player: Player) -> void:
	linear_velocity = Vector3.ZERO
	var garbage_impulse = hold_time * GARBAGE_IMPULSE_SCALE
	var player_impulse = hold_time * PLAYER_IMPULSE_SCALE
	
	apply_central_impulse(-dir * garbage_impulse)
	player.pushing_player(player_impulse)
	
	IS_DRAG = false
	HAND = null

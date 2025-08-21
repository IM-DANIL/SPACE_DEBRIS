class_name Garbage
extends RigidBody3D
var HAND: Hand

@export var HOLD_TIME: float = 5.0
@export var DEBRIS_IMPULSE: float = 5.0
@export var PLAYER_IMPULSE: float = 7.0

func _physics_process(delta: float) -> void:
	if HAND: _debris_movement()


func drop_object(pressing_time: float, dir: Vector3, player: Player) -> void:
	linear_velocity = Vector3.ZERO
	
	apply_central_impulse(-dir * pressing_time * DEBRIS_IMPULSE)
	player.pushing_player(pressing_time * PLAYER_IMPULSE)
	HAND = null


func _debris_movement() -> void:
	global_position = HAND.OBJECT_POS.global_position
	global_rotation = HAND.global_rotation
	rpc("_debris_sync", global_position)


@rpc("call_local", "any_peer")
func set_block_owner(peer_id):
	set_multiplayer_authority(peer_id)


@rpc("unreliable")
func _debris_sync(new_pos: Vector3) -> void:
	if not is_multiplayer_authority():
		global_position = new_pos

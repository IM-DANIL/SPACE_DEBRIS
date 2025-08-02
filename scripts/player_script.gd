class_name Player
extends CharacterBody3D
@onready var HANDS_RAYCAST: RayCast3D = $camera_node/camera/hands_raycast
@onready var CAMERA_NODE: Node3D = $camera_node

@export var is_multiplayer: bool = false

@export var LEFT_HAND: Hand
@export var RIGHT_HAND: Hand

@export var PLAYER_PARAM: Dictionary = {
	"CUR_SPEED": 0.0,
	"MIN_SPEED": 2.0,
	"MAX_SPEED": 6.0,
	"ACCEL": 1.5,
	"FRICT": 0.25,
	"FRICT_MULTIP": 0.15,
	
	"PULL_DIST": 4.0, 
	"PULL_SPEED": 4.0,
	"PULL_MULTIP": 3.0,
	
	"PUSH_FORSE": 7.5
}

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())


func _ready() -> void:
	_update_hands_raycast(PLAYER_PARAM.PULL_DIST)


func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority() and is_multiplayer: return
	
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"): _squeeze_hand(&"LEFT_HAND")
		elif event.is_action_released("left_click"): _unclench_hand(&"LEFT_HAND")
		if event.is_action_pressed("right_click"): _squeeze_hand(&"RIGHT_HAND")
		elif event.is_action_released("right_click"): _unclench_hand(&"RIGHT_HAND")


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority() and is_multiplayer: return
	
	_player_movement(delta)
	if LEFT_HAND.IS_SQUEEZE or RIGHT_HAND.IS_SQUEEZE:
		_handle_pull()
	
	
	global_position
	move_and_slide()


func _handle_pull() -> void:
	var avg_pull_point: Vector3 = Vector3.ZERO
	var active_hands = 0
	if LEFT_HAND.IS_SQUEEZE:
		avg_pull_point += LEFT_HAND.global_position
		active_hands += 1
	if RIGHT_HAND.IS_SQUEEZE:
		avg_pull_point += RIGHT_HAND.global_position
		active_hands += 1
	
	if active_hands > 0:
		avg_pull_point /= active_hands
	var direction_to_target = (avg_pull_point - global_position).normalized()
	var distance = global_position.distance_to(avg_pull_point)
	
	var current_speed = PLAYER_PARAM.PULL_SPEED * (PLAYER_PARAM.PULL_MULTIP if active_hands == 2 else 1.0)
	velocity = direction_to_target * current_speed * clamp(distance, 0, PLAYER_PARAM.PULL_DIST)


func _player_movement(delta: float) -> void: #finish_it
	if LEFT_HAND.IS_SQUEEZE or RIGHT_HAND.IS_SQUEEZE:
		if velocity.length() < 0.5: 
			PLAYER_PARAM.CUR_SPEED = lerp(PLAYER_PARAM.CUR_SPEED, PLAYER_PARAM.MIN_SPEED,\
			delta * PLAYER_PARAM.FRICT_MULTIP * PLAYER_PARAM.FRICT)
		elif  velocity.length() > 0.5:
			PLAYER_PARAM.CUR_SPEED = lerp(PLAYER_PARAM.CUR_SPEED, PLAYER_PARAM.MAX_SPEED, \
			delta * PLAYER_PARAM.ACCEL)
	else:
		PLAYER_PARAM.CUR_SPEED = lerp(PLAYER_PARAM.CUR_SPEED, PLAYER_PARAM.MIN_SPEED, delta * PLAYER_PARAM.FRICT)
	
	PLAYER_PARAM.CUR_SPEED  = clamp(PLAYER_PARAM.CUR_SPEED , PLAYER_PARAM.MIN_SPEED, PLAYER_PARAM.MAX_SPEED)
	velocity = velocity.limit_length(PLAYER_PARAM.CUR_SPEED)


func pushing_player(impulse: float) -> void:
	velocity = CAMERA_NODE.global_transform.basis.z.normalized() * impulse


func _squeeze_hand(hand: StringName) -> void:
	if get(hand):
		var _hand: Hand = get(hand)
		if _colliding_hands_raycast():
			if not _hand.IS_DRAG:
				if HANDS_RAYCAST.get_collider().is_in_group("debris"): #Drag_object
					_hand.drag_object(HANDS_RAYCAST.get_collider())
				elif not _hand.IS_SQUEEZE: #Squeeze_hand
					_hand.global_position = HANDS_RAYCAST.get_collision_point()
					_hand.IS_SQUEEZE = true


func _unclench_hand(hand: StringName) -> void:
	if get(hand):
		var _hand: Hand = get(hand)
		if _hand.IS_SQUEEZE:
			_hand.IS_SQUEEZE = false


func _colliding_hands_raycast() -> bool:
	if HANDS_RAYCAST.is_colliding():
		return HANDS_RAYCAST.global_position.distance_to(HANDS_RAYCAST.get_collision_point()) <= PLAYER_PARAM.PULL_DIST
	else: return false


func _update_hands_raycast(lenght: float) -> void:
	if abs(HANDS_RAYCAST.target_position.z) != lenght:
		HANDS_RAYCAST.target_position.z = -lenght

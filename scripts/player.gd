class_name Player
extends CharacterBody3D
@onready var HANDS_RAYCAST: RayCast3D = $camera_node/neck/Camera/RayCast
@onready var CAMERA_NODE: Node3D = $camera_node

var is_multiplayer: bool = false

@export var PARAMETERS: Dictionary = {
	"SPEED": 5.0,
	"MAX_PULL_DISTANCE": 5.0, 
	"PULL_SPEED": 10.0,
	"PULL_MULTIP": 2.0
}
var LEFT_HAND: Dictionary = {
	"NODE": null,
	"IS_PULL": false
}
var RIGHT_HAND: Dictionary = {
	"NODE": null,
	"IS_PULL": false
}

func _ready() -> void:
	_update_hand_raycast(PARAMETERS["MAX_PULL_DISTANCE"])


func _physics_process(delta: float) -> void:
	if not is_multiplayer: return
	
	if LEFT_HAND["IS_PULL"] or RIGHT_HAND["IS_PULL"]:
		_handle_pull(delta)
	_speed_movement(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer: return
	
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"): _start_pull_hand()
		if event.is_action_pressed("right_click"): _start_pull_hand(false)
		if event.is_action_released("left_click"): _end_pull_hand()
		if event.is_action_released("right_click"): _end_pull_hand(false)


func _handle_pull(_delta: float) -> void:
	var avg_pull_point: Vector3 = Vector3.ZERO
	var active_hands = 0
	if LEFT_HAND["IS_PULL"]:
		avg_pull_point += LEFT_HAND["NODE"].global_position
		active_hands += 1
	if RIGHT_HAND["IS_PULL"]:
		avg_pull_point += RIGHT_HAND["NODE"].global_position
		active_hands += 1
	
	if active_hands > 0:
		avg_pull_point /= active_hands
	var direction_to_target = (avg_pull_point - global_position).normalized()
	var distance = global_position.distance_to(avg_pull_point)
	
	var current_speed = PARAMETERS["PULL_SPEED"] * (PARAMETERS["PULL_MULTIP"] if active_hands == 2 else 1.0)
	velocity = direction_to_target * current_speed * clamp(distance, 0, PARAMETERS["MAX_PULL_DISTANCE"])


func _speed_movement(_delta: float) -> void:
	velocity = velocity.limit_length(PARAMETERS["SPEED"])


func _start_pull_hand(is_left: bool = true) -> void:
	if HANDS_RAYCAST.is_colliding():
		if _hands_raycast_colliding():
			if is_left:
				if LEFT_HAND["NODE"]:
					LEFT_HAND["NODE"].global_position = HANDS_RAYCAST.get_collision_point()
					LEFT_HAND["IS_PULL"] = true
					LEFT_HAND["NODE"].IS_PULL = LEFT_HAND["IS_PULL"]
			else: 
				if RIGHT_HAND["NODE"]:
					RIGHT_HAND["NODE"].global_position = HANDS_RAYCAST.get_collision_point()
					RIGHT_HAND["IS_PULL"] = true
					RIGHT_HAND["NODE"].IS_PULL = RIGHT_HAND["IS_PULL"]


func _end_pull_hand(is_left: bool = true) -> void:
	if is_left: 
		if LEFT_HAND["NODE"]:
			LEFT_HAND["IS_PULL"] = false
			LEFT_HAND["NODE"].IS_PULL = LEFT_HAND["IS_PULL"]
	else: 
		if RIGHT_HAND["NODE"]:
			RIGHT_HAND["IS_PULL"] = false
			RIGHT_HAND["NODE"].IS_PULL = RIGHT_HAND["IS_PULL"]


func _hands_raycast_colliding() -> bool:
	return HANDS_RAYCAST.global_position.distance_to(HANDS_RAYCAST.get_collision_point()) \
	 <= PARAMETERS["MAX_PULL_DISTANCE"]


func _update_hand_raycast(lenght_raycast: float) -> void:
	HANDS_RAYCAST.target_position.z = -lenght_raycast

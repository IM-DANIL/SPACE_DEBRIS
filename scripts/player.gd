class_name Player
extends CharacterBody3D
@onready var HANDS_RAYCAST: RayCast3D = $camera_node/neck/Camera/RayCast
@onready var FRICTION_AREA: Area3D = $friction_area
@export var AVG_POINT: MeshInstance3D #Testing AVG_POINT

var is_friction: bool = false

@export var PARAMETERS: Dictionary = {
	"MAX_SPEED": 5.0,
	"MIN_SPEED": 1.5,
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
	_check_hands()
	_update_hand_raycast(PARAMETERS["MAX_PULL_DISTANCE"])


func _physics_process(delta: float) -> void:
	if LEFT_HAND["IS_PULL"] or RIGHT_HAND["IS_PULL"]:
		_handle_pull(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"): _start_pull_hand()
		if event.is_action_pressed("right_click"): _start_pull_hand(false)
		if event.is_action_released("left_click"): _end_pull_hand()
		if event.is_action_released("right_click"): _end_pull_hand(false)


func _handle_pull(delta: float) -> void:
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
		if AVG_POINT: #Testing AVG_POINT
			AVG_POINT.global_position =  avg_pull_point
	var direction_to_target = (avg_pull_point - global_position).normalized()
	var distance = global_position.distance_to(avg_pull_point)
	
	var current_speed = PARAMETERS["PULL_SPEED"] * (PARAMETERS["PULL_MULTIP"] if active_hands == 2 else 1.0)
	velocity = direction_to_target * current_speed * clamp(distance, 0, PARAMETERS["MAX_PULL_DISTANCE"])
	velocity = velocity.limit_length(PARAMETERS["MAX_SPEED"])


func _friction(delta: float) -> void:
	pass


func _start_pull_hand(is_left: bool = true) -> void:
	if HANDS_RAYCAST.is_colliding():
		if _hands_raycast_colliding():
			if is_left: 
				LEFT_HAND["NODE"].global_position = HANDS_RAYCAST.get_collision_point()
				LEFT_HAND["IS_PULL"] = true
				LEFT_HAND["NODE"].IS_PULL = LEFT_HAND["IS_PULL"]
			else: 
				RIGHT_HAND["NODE"].global_position = HANDS_RAYCAST.get_collision_point()
				RIGHT_HAND["IS_PULL"] = true
				RIGHT_HAND["NODE"].IS_PULL = RIGHT_HAND["IS_PULL"]


func _end_pull_hand(is_left: bool = true) -> void:
	if is_left: 
		LEFT_HAND["IS_PULL"] = false
		LEFT_HAND["NODE"].IS_PULL = LEFT_HAND["IS_PULL"]
	else: 
		RIGHT_HAND["IS_PULL"] = false
		RIGHT_HAND["NODE"].IS_PULL = RIGHT_HAND["IS_PULL"]


func _check_hands() -> void:
	if get_tree().has_group("hand"):
		for hand in get_tree().get_nodes_in_group("hand"):
			if hand.IS_LEFT: LEFT_HAND["NODE"] = hand
			else: RIGHT_HAND["NODE"] = hand


func _hands_raycast_colliding() -> bool:
	return HANDS_RAYCAST.global_position.distance_to(HANDS_RAYCAST.get_collision_point()) \
	 <= PARAMETERS["MAX_PULL_DISTANCE"]


func _update_hand_raycast(lenght_raycast: float) -> void:
	HANDS_RAYCAST.target_position.z = -lenght_raycast


func _on_friction_area_body_shape_entered(_body_rid: RID, _body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	is_friction = true


func _on_friction_area_body_shape_exited(_body_rid: RID, _body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	is_friction = false

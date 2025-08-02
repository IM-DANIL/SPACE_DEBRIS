class_name Hand
extends CSGMesh3D
@onready var OBJECT_POS: Marker3D = $object_pos
@onready var HOLD_TIMER: Timer = $hold_timer
@onready var AWAIT_DRAG_TIMER: Timer = $await_drag_timer

@export var PLAYER: Player
@export var POS: Marker3D

var cur_object: Node3D

var IS_DRAG: bool = false
var IS_SQUEEZE: bool = false

@export var SPEED_HAND: float = 5.0
var HAND_NAMES_ARRAY: Array[String] = ["left", "right"]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_object_state(event)


func _physics_process(delta: float) -> void:
	_hand_movement(delta)


func _hand_movement(delta: float) -> void:
	if not IS_SQUEEZE: 
		global_position = lerp(global_position, POS.global_position, delta * SPEED_HAND)
		global_rotation = PLAYER.CAMERA_NODE.global_rotation


func _object_state(event: InputEvent) -> void:
	if HAND_NAMES_ARRAY.has(name):
		if IS_DRAG and AWAIT_DRAG_TIMER.is_stopped():
			if event.is_action_pressed(name + "_click"): HOLD_TIMER.start(cur_object.HOLD_TIME)
			elif event.is_action_released(name + "_click"): _drop_object()


func drag_object(object: Node3D) -> void:
	cur_object = object
	IS_DRAG = true
	
	cur_object.HAND = self
	cur_object.IS_DRAG = true
	
	AWAIT_DRAG_TIMER.start()


func _drop_object() -> void:
	var hold_time: float = 1.0 -(HOLD_TIMER.time_left / cur_object.HOLD_TIME)
	cur_object.drop_object(hold_time, PLAYER.CAMERA_NODE.global_transform.basis.z.normalized(), PLAYER)
	
	cur_object = null
	IS_DRAG = false

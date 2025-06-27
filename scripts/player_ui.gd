extends Control
@onready var HANDS_RAYCAST: RayCast3D = $"../../camera_node/neck/Camera/RayCast"
@onready var AIM_POINT: ColorRect = $aim_point

@export var BRIGHT_COLOR_AIM: Color
@export var DIM_COLOR_AIM: Color

func _process(delta: float) -> void:
	_check_pull_hand()


func _check_pull_hand() -> void:
	if HANDS_RAYCAST.is_colliding(): AIM_POINT.color = BRIGHT_COLOR_AIM
	else: AIM_POINT.color = DIM_COLOR_AIM

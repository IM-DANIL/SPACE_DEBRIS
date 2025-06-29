class_name CameraNode
extends Node3D
@onready var PLAYER: CharacterBody3D = $".."
@onready var NECK: Node3D = $neck
@onready var CAMERA: Camera3D = $neck/Camera

var IS_MULTIPLAYER: bool = false

@export var SENSITIVITY: float = 0.003
@export var SPEED_ROTATION: float = 3.0

func _unhandled_input(event: InputEvent) -> void:
	if not IS_MULTIPLAYER: return
	
	_camera_movement(event)


func _camera_movement(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_x(-event.relative.y * SENSITIVITY) 
			if 90 <= abs(rad_to_deg(rotation.x)) and abs(rad_to_deg(rotation.x)) <= 180:
				PLAYER.rotate_y(event.relative.x * SENSITIVITY)
			else: PLAYER.rotate_y(-event.relative.x * SENSITIVITY)


func update_camera() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CAMERA.current = true

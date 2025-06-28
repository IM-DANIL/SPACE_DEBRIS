extends Node3D
@onready var NECK: Node3D = $neck
@onready var CAMERA: Camera3D = $neck/Camera
@onready var PLAYER: CharacterBody3D = $".."

@export var SENSITIVITY: float = 0.003
@export var SPEED_ROTATION: float = 3.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #Testing
	#_multiplayer_camera() #Testing multiplayer


func _process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	#if not is_multiplayer_authority(): return #Testing multiplayer
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_x(-event.relative.y * SENSITIVITY) 
			if 90 <= abs(rad_to_deg(rotation.x)) and abs(rad_to_deg(rotation.x)) <= 180:
				PLAYER.rotate_y(event.relative.x * SENSITIVITY)
			else: PLAYER.rotate_y(-event.relative.x * SENSITIVITY)


func _physics_process(delta: float) -> void:
	_slant(delta)


func _slant(_delta: float) -> void:
	pass


#func _multiplayer_camera() -> void:
	#if not is_multiplayer_authority(): return
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#CAMERA.current = true

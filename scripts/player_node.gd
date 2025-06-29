class_name  PlayerNode
extends Node3D
@onready var PLAYER: Player = $player
@onready var CAMERA_NODE: Node3D = $player/camera_node

@export var IS_LOCAL: bool = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	_is_multiplayer()


func _is_multiplayer():
	if not IS_LOCAL:
		if not is_multiplayer_authority(): return
	PLAYER.IS_MULTIPLAYER = true
	CAMERA_NODE.IS_MULTIPLAYER = true
	CAMERA_NODE.update_camera()

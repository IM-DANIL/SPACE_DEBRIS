class_name  PlayerNode
extends Node3D
@onready var PLAYER: Player = $player
@onready var CAMERA_NODE: Node3D = $player/camera_node

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	if not is_multiplayer_authority(): return
	PLAYER.is_multiplayer = true
	CAMERA_NODE.is_multiplayer = true
	CAMERA_NODE.multiplayer_camera()

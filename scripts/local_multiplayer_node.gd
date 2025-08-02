class_name LocalMultiplayer
extends Control
@onready var PLAYER_SCENE: PackedScene = preload("res://scenes/player.tscn")
@onready var SERVER_BROADCAST: ServerBroadcast = $server_broadcast

@export var PARENT_SCENE: Node3D

@export var SERVER_BUTTON: Button
@export var CLIENT_BUTTON: Button
@export var CODE_EDIT: LineEdit
@export var CODE_LABEL: Label
@export var INFO_LABEL: Label

@onready var PEER: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
const PORT: int = 42069

func _ready() -> void:
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)


func _on_server_pressed() -> void:
	CLIENT_BUTTON.hide()
	CODE_EDIT.hide()
	CODE_LABEL.get_parent_control().visible = true
	
	var server_code: String = _generate_server_code()
	CODE_LABEL.text = server_code
	
	_create_server(server_code)


func _on_client_pressed() -> void:
	if CODE_EDIT.text:
		SERVER_BUTTON.hide()
		INFO_LABEL.get_parent_control().visible = true
		
		if CODE_EDIT.text == SERVER_BROADCAST.server_code:
			INFO_LABEL.text = "Сonnection is successful."
			_join_server("localhost")
			hide()
		else: INFO_LABEL.text = "Сonnection is failed."


func _create_server(_server_code: String) -> void:
	PEER.create_server(PORT)
	multiplayer.multiplayer_peer = PEER
	SERVER_BROADCAST.set_broadcast(_server_code)
	
	_add_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(_add_player)


func _join_server(IP_ADDRESS: String) -> void:
	PEER.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = PEER


func _add_player(id: int) -> void:
	if PARENT_SCENE:
		var _player: CharacterBody3D = PLAYER_SCENE.instantiate()
		_player.name = str(id)
		PARENT_SCENE.add_child(_player)
	else: printerr("Invalid Parent Scene.")


func _player_connected(id: int) -> void:
	print("Player %s connected." %str(id))


func _player_disconnected(id: int) -> void:
	print("Player %s disconnected." %str(id))
	if PARENT_SCENE.get_node(str(id)):
		PARENT_SCENE.get_node(str(id)).queue_free()


func _generate_server_code() -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var length = 4
	var result = ''
	for _n in range(length):
		var ascii = rng.randi_range(0, 25) + 65
		result += '%c' % ascii
	return result

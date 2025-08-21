extends Node
@onready var ENET_NETWORK_SCENE: PackedScene = preload("res://scenes/multiplayer/networks/enet_network.tscn")
@onready var STEAM_NETWORK_SCENE: PackedScene = preload("res://scenes/multiplayer/networks/steam_network.tscn" )
@export var _players_spawn_node: Node3D

enum MULTIPLAYER_NETWORK_TYPE {ENET, STEAM}
var active_network_type: MULTIPLAYER_NETWORK_TYPE = MULTIPLAYER_NETWORK_TYPE.ENET

var active_network

func _build_multiplayer_network() -> void:
	if not active_network:
		print("Setting active_network.")
		
		MultiplayerManager.multiplayer_mode_enabled = true
		
		match  active_network_type:
			MULTIPLAYER_NETWORK_TYPE.ENET:
				print("Setting network type to Enet.")
				_set_active_network(ENET_NETWORK_SCENE)
			MULTIPLAYER_NETWORK_TYPE.STEAM:
				print("Setting network type to Steam.")
				_set_active_network(STEAM_NETWORK_SCENE)
			_:
				print("No match for network type!")


func _set_active_network(active_network_scene) -> void:
	var network_scene_initialized = active_network_scene.instantiate()
	active_network = network_scene_initialized
	active_network._players_spawn_node = _players_spawn_node
	add_child(active_network)


func become_host(is_dedicated_server = false) -> void:
	_build_multiplayer_network()
	MultiplayerManager.host_mode_enabled = true if is_dedicated_server == false else false
	active_network.become_host()


func join_as_client(lobby_id = 0) -> void:
	_build_multiplayer_network()
	active_network.join_as_client(lobby_id)


func list_lobbies() -> void:
	_build_multiplayer_network()
	active_network.list_lobbies()

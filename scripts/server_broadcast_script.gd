class_name ServerBroadcast
extends Node
@onready var LOCAL_MULTIPLAYER_NODE: LocalMultiplayer = $".."
@onready var BROADCAST_TIMER: Timer = $broadcast_timer
@onready var MULTIPLAYER_NODE: LocalMultiplayer = $".."
@onready var IS_LISTNER: Label = $"../MarginContainer/VBoxContainer/is_listner"


var BROADCAST_IP: String = "192.168.0.255"
const BROADCAST_PORT: int = 8911
var BROADCAST: PacketPeerUDP
const LISTNER_PORT: int = 8912
var LISTNER: PacketPeerUDP

var server_code: String = ""
var server_ip
var server_info: Dictionary = {
	"server_code":""}

func _ready() -> void:
	_set_listner()


func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("player").size() == 2:
		BROADCAST_TIMER.stop()
		LOCAL_MULTIPLAYER_NODE.hide()
	
	if LISTNER.get_available_packet_count() > 0:
		var _server_ip = LISTNER.get_packet_ip()
		var bytes = LISTNER.get_packet()
		var data = bytes.get_string_from_ascii()
		var _server_info = JSON.parse_string(data) 
		
		server_code = _server_info.server_code
		print(server_code)
		server_ip = _server_ip


func _set_listner() -> void:
	LISTNER = PacketPeerUDP.new()
	
	if LISTNER.bind(LISTNER_PORT) == OK:
		print("Listner port %s successful." %str(LISTNER_PORT))
		IS_LISTNER.text = "Is listner: true."
	else: 
		print("Failed listner port.")
		IS_LISTNER.text = "Is listner: false."


func set_broadcast(server_code: String) -> void:
	server_info.server_code = server_code
	
	BROADCAST = PacketPeerUDP.new()
	BROADCAST.set_broadcast_enabled(true)
	BROADCAST.set_dest_address(BROADCAST_IP, LISTNER_PORT)
	
	if BROADCAST.bind(BROADCAST_PORT) == OK:
		print("Broadcast port %s successful." %str(BROADCAST_PORT))
	else: print("Failed broadcast port.")
	BROADCAST_TIMER.start()


func _on_broadcast_timer_timeout() -> void:
#	print("Broadcasting server.")
	var data = JSON.stringify(server_info)
	var packet = data.to_ascii_buffer()
	BROADCAST.put_packet(packet)


func _exit_tree() -> void:
	LISTNER.close()
	BROADCAST_TIMER.stop()
	if BROADCAST != null:
		BROADCAST.close()

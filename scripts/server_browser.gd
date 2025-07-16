extends Control
@onready var BROADCAST_TIMER: Timer = $broadcast_timer
@onready var ROOMS_CONTAINER: VBoxContainer = $"../buttons_panel/MarginContainer/multiplayer_menu/server_panel/VBoxContainer/MarginContainer/VBoxContainer"
@export var SERVER_INFO: PackedScene 

signal found_server
signal server_removed
signal join(ip)

var room_info: Dictionary = {
	"name": "name",
	"player_count": 0
}
var BROADCASTER: PacketPeerUDP
var LISTNER: PacketPeerUDP
const LISTNER_PORT: int = 8911
const BROADCAST_PORT: int = 8912
@export var broadcast_address: String = "192.168.0.255"

func _ready() -> void:
	set_up()


func _process(delta: float) -> void:
	if LISTNER.get_available_packet_count() > 0:
		var server_ip = LISTNER.get_packet_ip()
		var server_port = LISTNER.get_packet_port()
		var bytes = LISTNER.get_packet()
		var data = bytes.get_string_from_ascii()
		var _room_info = JSON.parse_string(data)
		
		print("IP: " + str(server_ip) + " PORT: " \
		 + str(server_port) + " ROOM INFO: " + str(_room_info))
		
		for i in ROOMS_CONTAINER.get_children():
			if i.name == room_info.name:
				i.get_node("ip").text = server_ip
				i.get_node("count").text = str(_room_info.player_count)
				return
		
		if SERVER_INFO:
			var current_info = SERVER_INFO.instantiate()
			current_info.name = room_info.name
			current_info.get_node("name").text = _room_info.name
			current_info.get_node("ip").text = server_ip
			current_info.get_node("count").text = str(int(_room_info.player_count))
			ROOMS_CONTAINER.add_child(current_info)
#			connect(current_info.join, join_ip)

func set_up() -> void:
	LISTNER = PacketPeerUDP.new()
	
	if LISTNER.bind(LISTNER_PORT) == OK:
		print("Bound to Listen port" + str(LISTNER_PORT) + "successful.")
	else: 
		print("Failed to bind to Listen port")


func set_broadcast(name) -> void:
	room_info.name = name
#	room_info.player_count = Players.size()
	BROADCASTER = PacketPeerUDP.new()
	BROADCASTER.set_broadcast_enabled(true)
	BROADCASTER.set_dest_address(broadcast_address, LISTNER_PORT)
	
	if BROADCASTER.bind(BROADCAST_PORT) == OK:
		print("Bound to Broadcast port" + str(BROADCAST_PORT) + "successful.")
	else: print("Failed to bind to broadcast port")
	BROADCAST_TIMER.start()


func _on_broadcast_timer_timeout() -> void:
	print("Broadcasting Game!")
	
#	room_info.player_count = Players.size()
	var data = JSON.stringify(room_info)
	var packet = data.to_ascii_buffer()
	BROADCASTER.put_packet(packet)


func clean_up() -> void:
	LISTNER.close()
	 
	BROADCAST_TIMER.stop()
	if BROADCASTER != null:
		BROADCASTER.close()


func _exit_tree() -> void:
	clean_up()


func join_ip(ip):
	join.emit(ip)

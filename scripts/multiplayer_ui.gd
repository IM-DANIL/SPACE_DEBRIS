extends Control
@onready var SERVER_BROWSER: Control = $server_browser
@onready var NAME_EDIT: LineEdit = $buttons_panel/MarginContainer/multiplayer_menu/VBoxContainer/name_container/name_edit


func _on_host_button_pressed() -> void:
	if NAME_EDIT.text != "":
		SERVER_BROWSER.set_broadcast(NAME_EDIT.text)

extends HBoxContainer
@onready var IP_LABEL: Label = $ip


signal join_game(ip)

func _on_join_pressed() -> void:
	join_game.emit(IP_LABEL.text)

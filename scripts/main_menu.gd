extends CanvasLayer
@onready var MAIN_UI: Control = $main_UI
@onready var MULTIPLAYER_UI: Control = $multiplayer_UI

func _on_multiplayer_button_pressed() -> void:
	MAIN_UI.hide()
	MULTIPLAYER_UI.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()

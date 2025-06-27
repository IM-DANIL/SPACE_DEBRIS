extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("escape"):
			get_tree().quit()
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()

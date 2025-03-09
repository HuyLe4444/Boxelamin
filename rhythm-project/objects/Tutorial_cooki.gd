extends Control

func _process(delta):
	if Input.is_action_just_pressed("button_Q"):
		get_tree().change_scene_to_file("res://levels/cooking.tscn")

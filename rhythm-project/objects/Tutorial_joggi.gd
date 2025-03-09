extends Control

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		get_tree().change_scene_to_file("res://levels/jogging.tscn")

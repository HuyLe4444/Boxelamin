extends Control

func _process(delta):
	if Input.is_action_just_pressed('space'):
		get_tree().change_scene_to_file("res://levels/wash_clothes.tscn")

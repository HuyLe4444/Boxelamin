extends Button

func _on_pressed():
	get_tree().change_scene_to_file("res://levels/game_map.tscn")

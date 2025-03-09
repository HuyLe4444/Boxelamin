extends Node2D

# Biến để theo dõi trạng thái của các nút trong phiên chơi hiện tại
var has_clicked_folding_button = false
var has_clicked_washing_button = false
var has_clicked_cooking_button = false
var has_clicked_jogging_button = false

var finished_count = 0

func _process(delta):
	if finished_count == 4:
		get_tree().change_scene_to_file("res://objects/outro.tscn")

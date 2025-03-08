extends Button

# Biến để theo dõi trạng thái nhấp nháy
var tween: Tween

func _ready():
	# Kiểm tra xem button đã được nhấn trước đó chưa trong phiên chơi hiện tại
	if not GlobalVariables.has_clicked_cooking_button:
		# Nếu chưa được nhấn, tạo hiệu ứng nhấp nháy
		start_blinking()
	else:
		# Nếu đã được nhấn trước đó, vô hiệu hóa button
		disabled = true
		modulate = Color(1, 1, 1, 0.5)  # Làm mờ nút để thể hiện rằng nó bị vô hiệu hóa

func start_blinking():
	# Tạo hiệu ứng nhấp nháy màu vàng
	tween = create_tween().set_loops()
	tween.tween_property(self, "modulate", Color(1, 1, 0, 0.7), 0.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)

func _on_pressed():
	# Dừng hiệu ứng nhấp nháy
	if tween:
		tween.kill()
	
	# Đặt lại màu về bình thường
	modulate = Color(1, 1, 1, 1)
	
	# Đánh dấu đã được nhấn trong phiên chơi hiện tại
	GlobalVariables.has_clicked_cooking_button = true
	
	# Chuyển sang scene khác
	get_tree().change_scene_to_file("res://levels/cooking.tscn")
	
	# Vô hiệu hóa button để không thể nhấn lại trong phiên chơi hiện tại
	disabled = true

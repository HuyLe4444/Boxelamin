extends Node2D

# Tải trước các hình ảnh sẽ được hiển thị luân phiên
@onready var image1 = preload("res://art/wash clothes - left.png")
@onready var image2 = preload("res://art/wash clothes - right.png")

# Tham chiếu đến sprite sẽ hiển thị hình ảnh
@onready var display_sprite = $DisplaySprite
@onready var instruction_label = $InstructionLabel
@onready var timer_label = $TimerLabel
@onready var score_label = $ScoreLabel
@onready var speed_label = $SpeedLabel

# Các biến theo dõi trạng thái game
enum GameMode { SPACE_PRESS, SPIN_MOUSE }
var current_mode = GameMode.SPACE_PRESS
var score: int = 0
var current_image: int = 0  # 0 cho image1, 1 cho image2

# Các biến cho chế độ bấm phím
var space_press_time: float = 10.0  # Thời gian bấm phím Space (giây)
var space_press_timer: float = 0.0
var space_press_count: int = 0
var space_key_pressed: bool = false

# Các biến cho chế độ xoay chuột
var spinning_time: float = 8.0  # Thời gian xoay chuột (giây)
var spinning_timer: float = 0.0
var center_position: Vector2
var last_angle: float = 0.0
var current_angle: float = 0.0
var total_rotation: float = 0.0
var is_spinning: bool = false
var rotation_threshold: float = 2 * PI  # Một vòng xoay hoàn chỉnh (360 độ)
var rotation_count: int = 0
var spin_speed_timer: float = 0.0
var rotation_speed: float = 0.0
var last_rotation_time: float = 0.0

# Đếm số lượt chơi
var round_count: int = 0
var max_rounds: int = 3  # Tổng 3 lượt chơi (6 giai đoạn: 3 space + 3 spin)

func _ready():
	# Get the viewport size
	var viewport_size = get_viewport_rect().size
	
	# Get the texture size of your background
	var texture_size = display_sprite.texture.get_size()
	
	# Calculate the scale needed to fit the screen
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	
	# Apply the scale to make it fit the screen
	display_sprite.scale = Vector2(scale_x, scale_y)
	
	# Xác định vị trí trung tâm
	center_position = get_viewport_rect().size / 2
	
	# Khởi tạo sprite hiển thị
	display_sprite.texture = image1
	
	# Khởi tạo các nhãn
	score_label.text = "Điểm: 0"
	speed_label.text = ""
	instruction_label.text = "BẤM PHÍM SPACE LIÊN TỤC!"
	timer_label.text = "Thời gian: %.1f" % space_press_time

func _process(delta):
	if round_count >= max_rounds:
		instruction_label.text = "GAME OVER! Điểm số cuối cùng: %d" % score
		timer_label.text = ""
		speed_label.text = ""
		return
		
	if current_mode == GameMode.SPACE_PRESS:
		_process_space_mode(delta)
	else:
		_process_spin_mode(delta)
	
	var viewport_size = get_viewport_rect().size
	var texture_size = display_sprite.texture.get_size()
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	display_sprite.scale = Vector2(scale_x, scale_y)

func _process_space_mode(delta):
	space_press_timer += delta
	
	# Cập nhật thời gian còn lại
	var time_left = space_press_time - space_press_timer
	timer_label.text = "Thời gian: %.1f" % max(0, time_left)
	
	# Hiển thị tần suất bấm phím
	var press_rate = space_press_count / space_press_timer if space_press_timer > 0 else 0
	speed_label.text = "Tốc độ: %.1f lần/giây" % press_rate
	
	# Kiểm tra nếu hết thời gian
	if space_press_timer >= space_press_time:
		_switch_to_spin_mode()

func _process_spin_mode(delta):
	spinning_timer += delta
	
	# Cập nhật thời gian còn lại
	var time_left = spinning_time - spinning_timer
	timer_label.text = "Thời gian: %.1f" % max(0, time_left)
	
	# Cập nhật tốc độ xoay
	if is_spinning:
		spin_speed_timer += delta
		if spin_speed_timer >= 0.5:  # Cập nhật tốc độ xoay mỗi 0.5 giây
			rotation_speed = total_rotation / (2 * PI * spin_speed_timer)
			speed_label.text = "Tốc độ: %.2f vòng/giây" % rotation_speed
			spin_speed_timer = 0.0
			total_rotation = 0.0
	
	# Kiểm tra nếu hết thời gian
	if spinning_timer >= spinning_time:
		round_count += 1
		if round_count < max_rounds:
			_switch_to_space_mode()
		else:
			# Kết thúc game sau 3 vòng
			instruction_label.text = "GAME OVER! Điểm số cuối cùng: %d" % score
			timer_label.text = ""
			speed_label.text = ""

func _input(event):
	if round_count >= max_rounds:
		return
		
	if current_mode == GameMode.SPACE_PRESS:
		_handle_space_input(event)
	else:
		_handle_spin_input(event)

func _handle_space_input(event):
	if event is InputEventKey and event.keycode == KEY_SPACE:
		if event.pressed and not space_key_pressed:
			space_key_pressed = true
			space_press_count += 1
			
			# Tính điểm và thay đổi hình ảnh
			var points = 10
			score += points
			score_label.text = "Điểm: %d" % score
			
			# Chuyển đổi hình ảnh
			current_image = 1 - current_image
			display_sprite.texture = image1 if current_image == 0 else image2
			
			# Hiển thị hiệu ứng điểm
			_show_points_effect(points)
		elif not event.pressed:
			space_key_pressed = false

func _handle_spin_input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_spinning = true
			
			# Tính góc giữa vị trí chuột và trung tâm
			var mouse_pos = get_viewport().get_mouse_position()
			var vector_to_center = mouse_pos - center_position
			
			# Bỏ qua chuyển động quá gần trung tâm
			if vector_to_center.length() < 10:
				return
				
			# Tính góc hiện tại
			current_angle = atan2(vector_to_center.y, vector_to_center.x)
			
			# Tính sự khác biệt góc
			var angle_diff = current_angle - last_angle
			
			# Chuẩn hóa sự khác biệt góc giữa -PI và PI
			if angle_diff > PI:
				angle_diff -= 2 * PI
			elif angle_diff < -PI:
				angle_diff += 2 * PI
				
			# Tích lũy tổng xoay
			total_rotation += abs(angle_diff)
			
			# Kiểm tra nếu một vòng xoay hoàn chỉnh đã được thực hiện
			if total_rotation >= rotation_threshold:
				_complete_rotation()
				total_rotation -= rotation_threshold
			
			# Lưu góc hiện tại cho frame tiếp theo
			last_angle = current_angle
		else:
			is_spinning = false
	
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Bắt đầu theo dõi chuyển động chuột
				var mouse_pos = get_viewport().get_mouse_position()
				var vector_to_center = mouse_pos - center_position
				last_angle = atan2(vector_to_center.y, vector_to_center.x)
				is_spinning = true
				last_rotation_time = Time.get_ticks_msec() / 1000.0
			else:
				# Dừng theo dõi
				is_spinning = false

func _complete_rotation():
	rotation_count += 1
	
	# Tính thời gian trôi qua từ vòng xoay hoàn chỉnh cuối cùng
	var current_time = Time.get_ticks_msec() / 1000.0
	var time_diff = current_time - last_rotation_time
	last_rotation_time = current_time
	
	# Tính tốc độ của vòng xoay cụ thể này
	var rotation_speed_instant = 1.0 / time_diff if time_diff > 0 else 0
	
	# Thêm điểm dựa trên tốc độ (nhanh hơn = nhiều điểm hơn)
	var points = 1000
	if rotation_speed_instant > 1.0:  # Thưởng cho xoay nhanh
		points = int(1000 * rotation_speed_instant)
	
	score += points
	score_label.text = "Điểm: %d" % score
	
	# Luân phiên giữa các hình ảnh
	current_image = 1 - current_image
	display_sprite.texture = image1 if current_image == 0 else image2
	
	# Hiệu ứng trực quan cho vòng xoay hoàn chỉnh
	_show_points_effect(points)

func _switch_to_space_mode():
	current_mode = GameMode.SPACE_PRESS
	space_press_timer = 0.0
	space_press_count = 0
	instruction_label.text = "BẤM PHÍM SPACE LIÊN TỤC!"
	speed_label.text = "Tốc độ: 0.0 lần/giây"

func _switch_to_spin_mode():
	current_mode = GameMode.SPIN_MOUSE
	spinning_timer = 0.0
	total_rotation = 0.0
	rotation_count = 0
	is_spinning = false
	instruction_label.text = "XOAY CHUỘT THEO HÌNH TRÒN!"
	speed_label.text = "Tốc độ: 0.0 vòng/giây"

func _show_points_effect(points):
	# Tạo nhãn tạm thời hiển thị điểm đã đạt được
	var points_label = Label.new()
	points_label.text = "+%d" % points
	
	if current_mode == GameMode.SPACE_PRESS:
		points_label.position = display_sprite.global_position - Vector2(20, 20)
	else:
		points_label.position = get_viewport().get_mouse_position() - Vector2(20, 20)
	
	points_label.add_theme_color_override("font_color", Color(1, 0.5, 0, 1))
	add_child(points_label)
	
	# Hoạt ảnh để làm biến mất nhãn
	var tween = create_tween()
	tween.tween_property(points_label, "position", points_label.position - Vector2(0, 50), 1.0)
	tween.tween_property(points_label, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_callback(points_label.queue_free)

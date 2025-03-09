extends CanvasLayer

# Nội dung văn bản sẽ hiển thị
@export_multiline var dialogue_text: String = "Xin chào! Đây là hộp thoại mẫu với hiệu ứng đánh chữ. Bạn có thể thay đổi nội dung này trong Inspector."

# Tốc độ đánh chữ (giây giữa mỗi ký tự)
@export_range(0.01, 0.2, 0.01) var typing_speed: float = 0.03

# Tham chiếu đến node UI
@onready var dialogue_box = $DialogueBox
@onready var text_label = $DialogueBox/TextLabel
@onready var type_timer = $TypeTimer

func _ready():
	# Bắt đầu hiệu ứng đánh chữ ngay khi scene khởi động
	start_dialogue()

func start_dialogue():
	# Thiết lập ban đầu
	text_label.text = ""
	type_timer.wait_time = typing_speed
	
	# Bắt đầu hiệu ứng đánh chữ
	display_text()

func display_text():
	var full_text = dialogue_text
	
	# Hiển thị từng ký tự một
	for i in range(full_text.length()):
		text_label.text += full_text[i]
		type_timer.start()
		await type_timer.timeout


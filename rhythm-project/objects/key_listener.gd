#extends Sprite2D
#
#@onready var falling_key = preload("res://objects/falling_key.tscn")
#@onready var falling_flower = preload("res://objects/falling_flowers.tscn")
#@onready var score_text = preload("res://objects/score_press_text.tscn")
#@export var key_name: String = ""
#
#var falling_key_queue = []
#
## If distance_from_pass is less than threshold, give that score
#var perfect_press_threshold: float = 40
#var great_press_threshold: float = 60
#var good_press_threshold: float = 80
#var ok_press_threshold: float = 100
## otherwise, miss
#
#var perfect_press_score: float = 250
#var great_press_score: float = 100
#var good_press_score: float = 50
#var ok_press_score: float = 20
#
#func _ready():
	##$GlowOverlay.frame = frame + 4
	#Signals.CreateFallingKey.connect(CreateFallingKey)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#
	##if Input.is_action_just_pressed(key_name):
		##Signals.KeyListenerPress.emit(key_name, frame)
	#
	## Make sure there is a falling key to check for this given key
	#if falling_key_queue.size() > 0:
		#
		## If that falling key has passed, remove it from the queue
		#if falling_key_queue.front().has_passed:
			#falling_key_queue.pop_front()
			#
			## PRINT MISS
			#var st_inst = score_text.instantiate()
			#get_tree().get_root().call_deferred("add_child", st_inst)
			#st_inst.SetTextInfo("MISS")
			#st_inst.global_position = global_position + Vector2(0, -20)
			#Signals.ResetCombo.emit()
			#
		## If key is pressed, pop from the queue and calculate distance from critical point
		#if Input.is_action_just_pressed(key_name):
			#var key_to_pop = falling_key_queue.pop_front()
			#
			#var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)
			#
			#$AnimationPlayer.stop()
			#$AnimationPlayer.play("key_hit")
			#
			#var press_score_text: String = ""
			#if distance_from_pass < perfect_press_threshold:
				#Signals.IncrementScore.emit(perfect_press_score)
				#press_score_text = "PERFECT"
				#Signals.IncrementCombo.emit()
			#elif distance_from_pass < great_press_threshold:
				#Signals.IncrementScore.emit(great_press_score)
				#press_score_text = "GREAT"
				#Signals.IncrementCombo.emit()
			#elif distance_from_pass < good_press_threshold:
				#Signals.IncrementScore.emit(good_press_score)
				#press_score_text = "GOOD"
				#Signals.IncrementCombo.emit()
			#elif distance_from_pass < ok_press_threshold:
				#Signals.IncrementScore.emit(ok_press_score)
				#press_score_text = "OK"
				#Signals.IncrementCombo.emit()
			#else:
				#press_score_text = "MISS"
				#Signals.ResetCombo.emit()
			#
			#key_to_pop.queue_free()
			#
			#var st_inst = score_text.instantiate()
			#get_tree().get_root().call_deferred("add_child", st_inst)
			#st_inst.SetTextInfo(press_score_text)
			#st_inst.global_position = global_position + Vector2(0, -20)
	#
	#
	#
#
#func CreateFallingKey(button_name: String):
	#if button_name == key_name:
		#if key_name == "left_click" or key_name == "right_click":
			#var fk_inst = falling_flower.instantiate()
			#get_tree().get_root().call_deferred("add_child", fk_inst)
			#fk_inst.Setup(position.x, frame + 4)
			#
			#falling_key_queue.push_back(fk_inst)
		#else:
			#var fk_inst = falling_key.instantiate()
			#get_tree().get_root().call_deferred("add_child", fk_inst)
			#fk_inst.Setup(position.x, frame + 4)
			#
			#falling_key_queue.push_back(fk_inst)
#
#
#func _on_random_spawn_timer_timeout():
	##CreateFallingKey()
	#$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	#$RandomSpawnTimer.start()

extends Sprite2D

@onready var falling_key = preload("res://objects/falling_key.tscn")
@onready var falling_flower = preload("res://objects/falling_flowers.tscn")
@onready var score_text = preload("res://objects/score_press_text.tscn")
@export var key_name: String = ""

# Add some input buffering
@export var input_buffer_time: float = 0.12  # seconds to buffer an input
var input_buffer_timer: float = 0.0
var input_buffered: bool = false

var falling_key_queue = []

# Make these exported to easily tweak from the inspector
@export_group("Scoring Thresholds")
@export var perfect_press_threshold: float = 40
@export var great_press_threshold: float = 60
@export var good_press_threshold: float = 80
@export var ok_press_threshold: float = 100

@export_group("Scoring Points")
@export var perfect_press_score: float = 250
@export var great_press_score: float = 100
@export var good_press_score: float = 50
@export var ok_press_score: float = 20

# Visual feedback
@export var hit_flash_duration: float = 0.15
var original_modulate: Color

func _ready():
	Signals.CreateFallingKey.connect(CreateFallingKey)
	original_modulate = modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle input buffering
	if input_buffer_timer > 0:
		input_buffer_timer -= delta
		if input_buffer_timer <= 0:
			input_buffered = false
	
	# Process key press
	if Input.is_action_just_pressed(key_name):
		input_buffered = true
		input_buffer_timer = input_buffer_time
	
	# Make sure there is a falling key to check for this given key
	if falling_key_queue.size() > 0:
		# If that falling key has passed, remove it from the queue
		if falling_key_queue.front().has_passed:
			falling_key_queue.pop_front()
			
			# PRINT MISS
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo("MISS")
			st_inst.global_position = global_position + Vector2(0, -20)
			Signals.ResetCombo.emit()
		
		# Check for upcoming note with input buffer
		elif input_buffered:
			var key_to_pop = falling_key_queue.front()
			var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)
			
			# Only hit if we're close enough
			if distance_from_pass < ok_press_threshold + 20:  # Added margin for buffer
				input_buffered = false  # Consume the buffered input
				falling_key_queue.pop_front()
				
				$AnimationPlayer.stop()
				$AnimationPlayer.play("key_hit")
				
				var press_score_text: String = ""
				if distance_from_pass < perfect_press_threshold:
					Signals.IncrementScore.emit(perfect_press_score)
					press_score_text = "PERFECT"
					Signals.IncrementCombo.emit()
					modulate = Color(1.0, 1.0, 0.3, 1.0)  # Yellow flash for perfect
				elif distance_from_pass < great_press_threshold:
					Signals.IncrementScore.emit(great_press_score)
					press_score_text = "GREAT"
					Signals.IncrementCombo.emit()
					modulate = Color(0.3, 1.0, 0.3, 1.0)  # Green flash
				elif distance_from_pass < good_press_threshold:
					Signals.IncrementScore.emit(good_press_score)
					press_score_text = "GOOD"
					Signals.IncrementCombo.emit()
					modulate = Color(0.3, 0.7, 1.0, 1.0)  # Blue flash
				elif distance_from_pass < ok_press_threshold:
					Signals.IncrementScore.emit(ok_press_score)
					press_score_text = "OK"
					Signals.IncrementCombo.emit()
					modulate = Color(0.7, 0.7, 0.7, 1.0)  # Gray flash
				else:
					press_score_text = "MISS"
					Signals.ResetCombo.emit()
					modulate = Color(1.0, 0.3, 0.3, 1.0)  # Red flash
				
				key_to_pop.OnHit()  # Call the hit animation on the key
				
				var st_inst = score_text.instantiate()
				get_tree().get_root().call_deferred("add_child", st_inst)
				st_inst.SetTextInfo(press_score_text)
				st_inst.global_position = global_position + Vector2(0, -20)
				
				# Reset modulate after flash
				await get_tree().create_timer(hit_flash_duration).timeout
				modulate = original_modulate

func CreateFallingKey(button_name: String):
	if button_name == key_name:
		if key_name == "left_click" or key_name == "right_click":
			var fk_inst = falling_flower.instantiate()
			get_tree().get_root().call_deferred("add_child", fk_inst)
			fk_inst.Setup(position.x, frame + 4)
			
			falling_key_queue.push_back(fk_inst)
		else:
			var fk_inst = falling_key.instantiate()
			get_tree().get_root().call_deferred("add_child", fk_inst)
			fk_inst.Setup(position.x, frame + 4)
			
			falling_key_queue.push_back(fk_inst)

func on_random_spawn_timer_timeout():
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()

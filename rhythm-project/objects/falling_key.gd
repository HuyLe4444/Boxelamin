#extends Sprite2D
#
#@export var fall_speed: float = 7.0
#
#var init_y_pos: float = -360
#
## true if falling key has passed the allowed input frame
#var has_passed: bool = false
#var pass_threshold = 320.0
#
#func _init():
	#set_process(false)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#global_position += Vector2(0, fall_speed)
	#
	#
	## Find out how long it takes for arrow to reach critical spot
	#if global_position.y > pass_threshold and not $Timer.is_stopped():
		## print($Timer.wait_time - $Timer.time_left)
		#$Timer.stop()
		#has_passed = true
#
#func Setup(target_x: float, target_frame: int):
	#global_position = Vector2(target_x, init_y_pos)
	#frame = target_frame
	#
	#set_process(true)
	#
#
#
#func _on_destroy_timer_timeout():
	#queue_free()
	
extends Sprite2D

@export var fall_speed: float = 7.0
@export var acceleration: float = 0.05  # Add slight acceleration for better feel
@export var init_y_pos: float = -360
# true if falling key has passed the allowed input frame
var has_passed: bool = false
var pass_threshold = 320.0

# Add visual feedback properties
var hit_effect_duration: float = 0.2
var hit_animation_active: bool = false
var hit_animation_timer: float = 0.0

func _init():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Use delta for frame-rate independent movement
	global_position += Vector2(0, fall_speed * delta * 60)
	
	# Gradually increase speed for better anticipation
	fall_speed += acceleration * delta
	
	# Handle visual feedback animation
	if hit_animation_active:
		hit_animation_timer -= delta
		modulate.a = 1.0 - (hit_animation_timer / hit_effect_duration)
		scale = Vector2(1 + hit_animation_timer/hit_effect_duration * 0.5, 
						1 + hit_animation_timer/hit_effect_duration * 0.5)
		
		if hit_animation_timer <= 0:
			hit_animation_active = false
			modulate.a = 0
	
	# Find out how long it takes for arrow to reach critical spot
	if global_position.y > pass_threshold and not $Timer.is_stopped():
		$Timer.stop()
		has_passed = true

func Setup(target_x: float, target_frame: int):
	global_position = Vector2(target_x, init_y_pos)
	frame = target_frame
	modulate.a = 1.0
	scale = Vector2(1, 1)
	hit_animation_active = false
	set_process(true)

func OnHit():
	# Start hit animation
	hit_animation_active = true
	hit_animation_timer = hit_effect_duration

func on_destroy_timer_timeout():
	queue_free()

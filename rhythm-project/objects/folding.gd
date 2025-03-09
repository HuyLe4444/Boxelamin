extends Node2D

var count = 0
var sit = preload("res://art/sitting.png")
var left = preload("res://art/to the left.png")
var right = preload("res://art/to the right.png")

func _ready():
	$Timer.start()
	# Get the viewport size
	var viewport_size = get_viewport_rect().size
	
	# Get the texture size of your background
	var texture_size = $Background.texture.get_size()
	
	# Calculate the scale needed to fit the screen
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	
	# Apply the scale to make it fit the screen
	$Background.scale = Vector2(scale_x, scale_y)

func _process(delta):
	if Input.is_action_just_pressed("button_Q"):
		$Background.texture = left
	elif Input.is_action_just_pressed("button_W"):
		$Background.texture = sit
	elif Input.is_action_just_pressed("button_E"):
		$Background.texture = right
		
	# Recalculate scale when texture changes
	var viewport_size = get_viewport_rect().size
	var texture_size = $Background.texture.get_size()
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	$Background.scale = Vector2(scale_x, scale_y)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://levels/toilet.tscn")

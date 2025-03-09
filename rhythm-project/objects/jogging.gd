extends Node2D

func _ready():
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
	if Input.is_action_just_pressed("left_click"):
		$AnimatedSprite2D.position.x = -80.0
	elif Input.is_action_just_pressed("right_click"):
		$AnimatedSprite2D.position.x = 80.0
		
	# Recalculate scale when texture changes
	var viewport_size = get_viewport_rect().size
	var texture_size = $Background.texture.get_size()
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	$Background.scale = Vector2(scale_x, scale_y)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://levels/game_map.tscn")

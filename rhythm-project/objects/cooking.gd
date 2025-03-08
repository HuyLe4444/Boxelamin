extends Node2D

var count = 0
var image_1 = preload("res://art/cooking down - sizzle 1.png")
var image_2 = preload("res://art/cooking up - sizzle.png")

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
	if Input.is_action_just_pressed("button_Q"):
		count += 1
		if count % 2 == 0:
			$Background.texture = image_1
		else:
			$Background.texture = image_2
		
		# Recalculate scale when texture changes
		var viewport_size = get_viewport_rect().size
		var texture_size = $Background.texture.get_size()
		var scale_x = viewport_size.x / texture_size.x
		var scale_y = viewport_size.y / texture_size.y
		$Background.scale = Vector2(scale_x, scale_y)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://levels/game_map.tscn")

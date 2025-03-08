extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if input_direction == Vector2(0, 0):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("down")
	
func _physics_process(delta):
	get_input()
	move_and_slide()

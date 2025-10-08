extends KinematicBody2D
onready var sprite = $AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2.ZERO
var input
export var speed = 100
export var gravity = 10
export var jump_force = 300
export var max_jump = 2
var jump_left = 0

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	movement(delta)



# Called when the node enters the scene tree for the first time.
	
func  movement(delta):
	input = sign(Input.get_action_strength("right") - Input.get_action_strength("left"))
	
	if input != 0:
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed , 100 , speed)
			sprite.play("run")
			sprite.flip_h = false
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(speed , 100 , -speed)
			sprite.flip_h = true
			sprite.play("run")
	if input == 0:
		velocity.x = 0
		sprite.play("Idle")
			
	gravity_force()
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		jump_left = max_jump
	
	
	if Input.is_action_just_pressed("jump") and jump_left > 0:
		velocity.y = -jump_force
		jump_left -= 1
	if input == 0:
		velocity.x = 0
	if !is_on_floor():
		if velocity.y < 0:
			sprite.play("Jump")
		if velocity.y > 0:
			sprite.play("Jump")
	if Input.is_action_pressed("pause"):
		get_tree().paused = true

func gravity_force():
	velocity.y += gravity
	
func die():
	print("Player Dead!")


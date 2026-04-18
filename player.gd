extends Area2D
signal hit

@export var speed = 800/Global.difficulty # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	#velocity += Global.joystick_direction
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x > 0:
		Global.animation = "right"
	elif velocity.y > 0:
		Global.animation = "down"
	elif velocity.x < 0:
		Global.animation = "left"
	elif velocity.y < 0:
		Global.animation = "up"
	if Global.animation != "" && !Global.animation.ends_with("fire") && Global.fire:
		Global.animation += "_fire"
	$AnimatedSprite2D.animation = Global.animation
	
func _on_body_entered(body: Node2D) -> void:
	hit.emit(body)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

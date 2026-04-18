extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var game_area = get_parent().get_node("Background")

	if position.x < game_area.position.x \
	or position.x > game_area.position.x + game_area.size.x \
	or position.y < game_area.position.y \
	or position.y > game_area.position.y + game_area.size.y:
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

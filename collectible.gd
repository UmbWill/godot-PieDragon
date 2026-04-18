extends RigidBody2D
signal collected
signal lost


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var game_area = get_parent().get_node("Background")

	if position.x < game_area.position.x \
	or position.x > game_area.position.x + game_area.size.x \
	or position.y < game_area.position.y \
	or position.y > game_area.position.y + game_area.size.y:
		emit_signal("lost")
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	print_debug("body.name : ", body.name )
	if body.name == "Player":
		collected.emit()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	emit_signal("lost")
	queue_free()
	
func remove_collectible():
	$AnimationPlayer.play("disappear")
	await $AnimationPlayer.animation_finished
	emit_signal("collected_or_lost")
	queue_free()

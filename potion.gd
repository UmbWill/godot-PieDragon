extends RigidBody2D
signal fire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#make_semi_transparent()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var game_area = get_parent().get_node("Background")

	if position.x < game_area.position.x \
	or position.x > game_area.position.x + game_area.size.x \
	or position.y < game_area.position.y \
	or position.y > game_area.position.y + game_area.size.y:
		queue_free()
	


func make_semi_transparent():
	pass
	#$Sprite2D.modulate.a = 0.5
	#await get_tree().create_timer(10.0).timeout
	#$Sprite2D.modulate.a = 1.0


func _on_body_entered(body: Node2D) -> void:
	print_verbose(body.name)
	#if body.name == "Player":
	fire.emit()
	queue_free()

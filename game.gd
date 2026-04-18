extends Node
@export var mob_scene: PackedScene
@export var collectible_scene: PackedScene
@export var potion_scene: PackedScene
signal game_won
signal game_over_apple
signal game_over_bat
var score
var collectibles_left = 0
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = $Background.size
	new_game()

func _on_player_hit(body: Node2D) -> void:
	#print("body.name : ", body.name )
	if body.is_in_group("collectible"):
		_on_collectible_collected()
		body.queue_free()
	elif body.is_in_group("potion"):
		_on_potion_fire()
		body.queue_free()
	elif body.is_in_group("mob") and collectibles_left > 0:
		if Global.fire:
			body.queue_free()
		elif Global.alive:
			Global.alive = false
			game_over_bat.emit()
			game_over()
			
func game_over() -> void:
	$MobTimer.stop()
	$Player.queue_free()	
	#queue_free()

func new_game():
	score = 0
	spawn_collectibles()
	spawn_potion()
	$Player.start($StartPosition.position)
	
		# Create a new instance of the Mob scene.
	#var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	#var mob_spawn_location = $MobPath/MobSpawnLocation
	#mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	#mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	#var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction

	# Choose the velocity for the mob.
	#var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	#add_child(mob)
	$MobTimer.start()

func spawn_collectibles() -> void:
	collectibles_left = Global.difficulty

	for i in Global.difficulty:
		var item = collectible_scene.instantiate()
		
		item.position = Vector2(
			randf_range(50, screen_size.x - 50),
			randf_range(50, screen_size.y - 50)
		)

		item.collected.connect(_on_collectible_collected)
		item.lost.connect(_on_collectible_lost)
		

		add_child(item)

func spawn_potion() -> void:
	if Global.difficulty < 8:
		var item = potion_scene.instantiate()
		
		item.position = Vector2(
			randf_range(50, screen_size.x - 50),
			randf_range(50, screen_size.y - 50)
		)
		item.fire.connect(_on_potion_fire)
		add_child(item)
	
	
		
func _on_collectible_collected() -> void:
	collectibles_left -= 1
	#print("collectibles_left : ", collectibles_left )
	if collectibles_left <= 0:
		score += 1
		game_won.emit()
		$MobTimer.stop()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(50.0, 100.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	

func _on_collectible_lost() -> void:
	if (collectibles_left > 0 && Global.alive):
		Global.alive = false		
		game_over_apple.emit()
		game_over()
	
func _on_potion_fire() -> void:
	Global.fire = true
	$PotionTimer.start()


func _on_potion_timer_timeout() -> void:
	Global.fire = false

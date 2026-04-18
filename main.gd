extends Node
@export var mob_scene: PackedScene
@export var collectible_scene: PackedScene
@export var potion_scene: PackedScene
var score
var collectibles_left = 0
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Game.game_won.connect(_on_game_game_won)
	$Game.game_over_apple.connect(_on_game_game_over_apple)
	$Game.game_over_bat.connect(_on_game_game_over_bat)
	screen_size = get_viewport().get_visible_rect().size
	var d = $CanvasLayer/DifficultySelect
	d.add_item("Easy", 0)
	d.add_item("Normal", 1)
	d.add_item("Hard", 2)
	d.select(Global.selected_level)
	

func _on_difficulty_select_item_selected(index) -> void:
	Global.selected_level = index
	match index:
		0:
			Global.difficulty = 4
		1:
			Global.difficulty = 6
		2:
			Global.difficulty = 8
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_game_won():
	print("game won" )
	$CanvasLayer/RestartButton.visible = true	
	$CanvasLayer/WinLabel.modulate = Color.YELLOW
	show_message_popup("win_popup", "YOU WIN!" )# Score: " + str(score))
	
func _on_game_game_over_apple():
	$CanvasLayer/RestartButton.visible = true
	$CanvasLayer/WinLabel.modulate = Color.RED
	show_message_popup("lose_popup", "You lost an apple!")

func _on_game_game_over_bat():
	$CanvasLayer/RestartButton.visible = true	
	$CanvasLayer/WinLabel.modulate = Color.RED
	show_message_popup("lose_popup", "GAME OVER")
	
func _on_restart_button_pressed() -> void:
	Global.alive = true
	Global.animation = "left"
	Global.fire = false
	get_tree().reload_current_scene()
	
func show_message_popup(animation_type : String, message : String) -> void:
	$CanvasLayer/AnimationPlayer.play(animation_type)
	$CanvasLayer/WinLabel.text = message
	$CanvasLayer/WinLabel.show()

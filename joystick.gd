extends Control

@export var radius := 80.0

var dragging := false
var direction := Vector2.ZERO

@onready var knob := $Knob
@onready var base_pos := global_position

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if (event.position - global_position).length() < radius:
				dragging = true
		else:
			dragging = false
			Global.joystick_direction = Vector2.ZERO
			knob.position = Vector2.ZERO

	elif event is InputEventScreenDrag and dragging:
		var offset = event.position - global_position
		offset = offset.limit_length(radius)

		knob.position = offset
		Global.joystick_direction = offset / 80

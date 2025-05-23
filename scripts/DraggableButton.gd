extends Button

signal dropped(button)

var dragging := false
var offset := Vector2.ZERO

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = get_global_mouse_position() - global_position
			z_index = 100  # Поднять над остальными
		else:
			if dragging:
				dragging = false
				emit_signal("dropped", self)

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() - offset

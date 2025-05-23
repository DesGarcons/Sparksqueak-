extends Control

@onready var root_container := $Container/Panel/RootVBoxContainer

var wires: Array
var completed := false


func _ready():
	hide_ui()


func toggle_ui():
	if visible:
		hide_ui()
	else:
		show_ui()


func show_ui():
	G.player.use_ui = true

	visible = true
	mouse_filter = MOUSE_FILTER_STOP 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_ui()
	

func hide_ui():
	G.player.use_ui = false

	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func set_wires(new_wires: Array):
	wires = new_wires
	completed = false 


func get_changed_wires() -> Array:
	var changes := []
	for container in root_container.get_children():
		if container.get_child_count() == 0:
			continue
		var child = container.get_child(0)
		if child is Button:
			changes.append(child.get_meta("value"))
	wires = changes.duplicate() 
	return changes


func update_ui():
	if wires.size() == 0:
		return
	var containers = root_container.get_children()
	for container in containers:
		for child in container.get_children():
			container.remove_child(child)
			child.queue_free()

	for i in range(containers.size()):
		var btn = load("res://scripts/DraggableButton.gd").new()
		btn.size_flags_vertical = SIZE_EXPAND_FILL
		
		var image := Image.create(128, 64, false, Image.FORMAT_RGBA8)
		if wires[i].contains("red"):
			image.fill(Color.RED)
		elif wires[i].contains("blue"):
			image.fill(Color.BLUE)
		elif wires[i].contains("green"):
			image.fill(Color.GREEN)
		elif wires[i].contains("orange"):
			image.fill(Color.ORANGE)
		var texture := ImageTexture.create_from_image(image)
		btn.icon = texture 
		btn.set_meta("value", wires[i])

		# btn.text = wires[i]


		btn.connect("dropped", Callable(self, "_on_label_dropped"))
		containers[i].add_child(btn)



func _on_label_dropped(dragged_button: Button):
	
	var mouse_pos = get_viewport().get_mouse_position()
	var all_buttons := []

	for container in root_container.get_children():
		for child in container.get_children():
			if child != dragged_button:
				all_buttons.append(child)

	for target_button in all_buttons:
		if target_button.get_global_rect().has_point(mouse_pos):
			var parent_a = dragged_button.get_parent()
			var parent_b = target_button.get_parent()
			var index_a = parent_a.get_children().find(dragged_button)
			var index_b = parent_b.get_children().find(target_button)

			parent_a.remove_child(dragged_button)
			parent_b.remove_child(target_button)

			parent_a.add_child(target_button)
			parent_b.add_child(dragged_button)

			parent_a.move_child(target_button, index_a)
			parent_b.move_child(dragged_button, index_b)
			
			return

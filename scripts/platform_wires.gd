extends Node3D

@export var WIRE_COUNT := 4

@onready var interact_ui = $InteractUI
@onready var outline := $Outline

var wires_on_object: Array
var player_in_range := false

var textures = [
	'res://material/wire/green_wire_material.tres',
	'res://material/wire/orange_wire_material.tres',
	'res://material/wire/blue_wire_material.tres',
	'res://material/wire/red_wire_material.tres'
]

func _ready():
	# wires_on_object.clear()
	
	var child_nodes = get_child(0).get_child(0).get_child(1).get_children()
	var used_wires: Array
	var shuffled = textures.duplicate()
	shuffled.shuffle()
	used_wires = shuffled.slice(0, WIRE_COUNT)
	
	for idx in range(WIRE_COUNT):
		var mesh = child_nodes[idx]
		if mesh is MeshInstance3D:
			var path_texture = used_wires[idx]
			var loaded_material = ResourceLoader.load(path_texture)
			if loaded_material and mesh.mesh.get_surface_count() > 0:
				var material_instance = loaded_material.duplicate()
				material_instance.set_meta("name", path_texture.split("/wire/")[1].split(".")[0])
				mesh.set_surface_override_material(0, material_instance)
				wires_on_object.append(path_texture)

func _process(delta):
	var changes = interact_ui.get_changed_wires()
	if changes and changes != wires_on_object:
		_fill_wires(changes)
		wires_on_object = changes

	
	if player_in_range and Input.is_action_just_pressed("Interact"):
		G.player.play_animation("Interact")
		interact_ui.set_wires(wires_on_object)
		interact_ui.toggle_ui()


func _on_area_3d_body_entered(body:Node3D) -> void:
	if body.name == "Player":
		player_in_range = true
		outline.visible = true
		
			
func _on_area_3d_body_exited(body:Node3D) -> void:
	if body.name == "Player":
		player_in_range = false
		interact_ui.hide_ui()
		outline.visible = false


func _fill_wires(array_wires: Array):

	wires_on_object.clear()
	
	var child_nodes = $platform/Node/wires.get_children()
	
	for idx in range(child_nodes.size()):
		if idx >= array_wires.size():
			break
		var mat_a = child_nodes[idx].get_active_material(0)
		if mat_a == null or not mat_a.has_meta("name"):
			continue

		var name_material = array_wires[idx].split("/wire/")[1].split(".")[0]
		var current_name = mat_a.get_meta("name")

		if name_material == current_name:
			continue

		if name_material != current_name:
			for j in range(child_nodes.size()):
				var mat_b = child_nodes[j].get_active_material(0)
				if mat_b == null or not mat_b.has_meta("name"):
					continue

				if name_material == mat_b.get_meta("name"):
					swap_meshes(child_nodes[idx], child_nodes[j])
					child_nodes = $platform/Node/wires.get_children()
					break



	
	
func swap_meshes(a: MeshInstance3D, b: MeshInstance3D):
	var parent_a = a.get_parent()
	var parent_b = b.get_parent()

	var index_a = parent_a.get_children().find(a)
	var index_b = parent_b.get_children().find(b)

	var transform_a = a.global_transform
	var transform_b = b.global_transform

	parent_a.remove_child(a)
	parent_b.remove_child(b)

	parent_a.add_child(b)
	parent_b.add_child(a)

	parent_a.move_child(b, index_a)
	parent_b.move_child(a, index_b)

	a.global_transform = transform_b
	b.global_transform = transform_a
extends Node3D



func _on_area_3d_area_entered(area:Area3D) -> void:


	var parent_node: Node = area.get_parent()

	if parent_node.has_meta("SourceEnergy"):
		if parent_node.get_meta("SourceEnergy"):
			pass

	# if parent_node.get_parent() is MeshInstance3D:
	# 	var type_wire: StandardMaterial3D = parent_node.get_parent().get_active_material(0)
	# 	print("Side ", parent_node, "type ", type_wire.get_meta("name"))
	# else:
	# 	print("Name: ", parent_node)

extends Area3D



func _ready():
	self.connect("area_entered", Callable(self, "_on_area_3d_area_entered"))


# func _on_area_3d_area_entered(area: Area3D) -> void:
# 	var self_parent = self.get_parent()
# 	var other_parent = area.get_parent()
	
# 	if other_parent.has_meta("SourceEnergy"):
# 		enable_emission_material(self_parent.get_parent().get_active_material(0))
		
# 	if self_parent.has_meta("SourceEnergy"):
# 		enable_emission_material(other_parent.get_parent().get_active_material(0))

# 	if not other_parent.has_meta("SourceEnergy") and not self_parent.has_meta("SourceEnergy"):
# 		var material_self = self_parent.get_parent().get_active_material(0)
# 		var material_another = other_parent.get_parent().get_active_material(0)

# 		if self_parent.name != other_parent.name:
# 			if material_self.has_meta("name") and material_another.has_meta("name"):
				
# 				var name_self = material_self.get_meta("name")
# 				var name_another = material_another.get_meta("name")

# 				if name_self == name_another:
# 					enable_emission_material(material_self)
# 					enable_emission_material(material_another)
# 					return

# 				if name_self != name_another:
# 					if not material_self.has_meta("energy_first"):
# 						material_self.emission_enabled = false
# 						return

# 					if not material_another.has_meta("energy_first"):
# 						material_another.emission_enabled = false
# 						return


func _on_area_3d_area_entered(area: Area3D) -> void:
	var self_parent = self.get_parent()
	var other_parent = area.get_parent()

	var mesh_self = self_parent.get_parent() as MeshInstance3D
	var mesh_another = other_parent.get_parent() as MeshInstance3D
	if not mesh_self or not mesh_another:
		return

	var material_self = mesh_self.get_active_material(0)
	var material_another = mesh_another.get_active_material(0)

	# Если один из родителей — источник
	if other_parent.has_meta("SourceEnergy"):
		enable_emission_material(material_self)
		return
	if self_parent.has_meta("SourceEnergy"):
		enable_emission_material(material_another)
		return

	if self_parent.name != other_parent.name:
		if material_self.has_meta("name") and material_another.has_meta("name"):
			var name_self = material_self.get_meta("name")
			var name_another = material_another.get_meta("name")

			if name_self == name_another:
				enable_emission_material(material_self)
				enable_emission_material(material_another)
			else:
				if not is_touching_source_energy(self):
					material_self.emission_enabled = false
				if not is_touching_source_energy(area):
					material_another.emission_enabled = false


func is_touching_source_energy(area_node: Area3D) -> bool:
	for other_area in area_node.get_overlapping_areas():
		var other_parent = other_area.get_parent()
		if other_parent and other_parent.has_meta("SourceEnergy"):
			return true
	return false


func enable_emission_material(material: StandardMaterial3D):
	material.set_meta("energy_first", true)

	material.emission_enabled = true
	material.emission_energy_multiplier = 1.0
	if not material.has_meta("name"):
		return
	
	var material_name = material.get_meta("name") 

	if material_name.contains("red"):
		material.emission = Color.RED
		return
	if material_name.contains("green"):
		material.emission = Color.GREEN
		return
	if material_name.contains("blue"):
		material.emission = Color.BLUE
		return
	if material_name.contains("orange"):
		material.emission = Color.ORANGE
		return

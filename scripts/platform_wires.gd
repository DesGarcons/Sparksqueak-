extends StaticBody3D

var textures = [
	'res://material/wire/green_wire_material.tres',
	'res://material/wire/orange_wire_material.tres',
    'res://material/wire/blue_wire_material.tres'
]

func _ready():
    var wires :Array[Node] = []

    var child_nodes = get_children()
    for node in child_nodes:
        if node.name.begins_with("wire"):
            wires.append(node)

    for wire in wires:
        var mesh = wire.get_child(0).get_child(0)
        print("Mesh type:", mesh)
        if mesh is MeshInstance3D:
            print("Surface count:", mesh.mesh.get_surface_count())
            
            var random_path = textures[randi() % textures.size()]
            var loaded_material = ResourceLoader.load(random_path)
            print("Material:", loaded_material)

            if loaded_material and mesh.mesh.get_surface_count() > 0:
                var material_instance = loaded_material.duplicate()
                mesh.set_surface_override_material(0, material_instance)

		

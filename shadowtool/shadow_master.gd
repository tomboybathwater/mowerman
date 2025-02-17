extends Node2D

var lawn_builder : PackedScene

# Path to the shadow scene
var shadow_scene := preload("res://shadowtool/sprite_shadow.tscn")

func _ready() -> void:
	
	# Check if the nodes exist and process their descendants recursively
	if get_parent().get_node("LawnMower"):
		_process_descendants_for_shadows(get_parent().get_node("LawnMower"))
	if get_parent().get_node("LawnBuilder"):
		_process_descendants_for_shadows(get_parent().get_node("LawnBuilder"))
		get_parent().get_node("LawnBuilder").new_chunk.connect(_process_new_chunk)

# Helper function to recursively process all descendants of a node and add shadows
func _process_descendants_for_shadows(parent_node: Node) -> void:
	# Iterate through the children of the given parent node
	for child in parent_node.get_children():
		# Skip checking children if the child is a Sprite2D
		if child is Sprite2D:
			if not child.is_in_group("shadow") && child.visible == true:
				# Create an instance of the shadow scene
				var shadow_instance = shadow_scene.instantiate()
				# Add the shadow instance as a child of the current sprite
				
				shadow_instance.show_behind_parent = true
				shadow_instance.z_as_relative = false
				shadow_instance.z_index = 0
				child.add_child(shadow_instance)
				
		else:
			# Recursively check the child's descendants (if any)
			_process_descendants_for_shadows(child)

func _process_new_chunk(chunk: Node):
	_process_descendants_for_shadows(chunk)

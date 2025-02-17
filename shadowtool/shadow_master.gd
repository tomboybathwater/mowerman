extends Node2D

# Path to the shadow scene
var shadow_scene := preload("res://shadowtool/sprite_shadow.tscn")

func _ready() -> void:
	# Get references to LawnMower and LevelParts nodes
	var lawn_mower_node = get_parent().get_node("LawnMower")
	var level_parts_node = get_parent().get_node("LevelParts")

	# Check if the nodes exist and process their descendants recursively
	if lawn_mower_node:
		_process_descendants_for_shadows(lawn_mower_node)
	if level_parts_node:
		_process_descendants_for_shadows(level_parts_node)

# Helper function to recursively process all descendants of a node and add shadows
func _process_descendants_for_shadows(parent_node: Node) -> void:
	# Iterate through the children of the given parent node
	for child in parent_node.get_children():
		# Skip checking children if the child is a Sprite2D
		if child is Sprite2D:
			if not child.is_in_group("shadow"):
				# Create an instance of the shadow scene
				var shadow_instance = shadow_scene.instantiate()
				# Add the shadow instance as a child of the current sprite
				child.add_child(shadow_instance)
		else:
			# Recursively check the child's descendants (if any)
			_process_descendants_for_shadows(child)

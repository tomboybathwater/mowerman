extends Node2D

@export var grass_tile : PackedScene
@export var tile_y_offset := -2051

func _ready() -> void:
	_spawn_next_tile()
	
func _spawn_next_tile():
	var new_grass_tile_scene = grass_tile.instantiate()
	new_grass_tile_scene.position += Vector2(0, tile_y_offset)
	add_child(new_grass_tile_scene)

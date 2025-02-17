extends Node2D

@export var grass_tile : PackedScene
@export var fence_tile : PackedScene
@export var tile_y_offset := -2045

var tile_next_y_position := 0 

@onready var tile_holder: Node2D = $TileHolder
@onready var fence_holder: Node2D = $FenceHolder
@onready var area_2d_spawner: Area2D = $Area2D_Spawner

signal new_chunk(chunk: PackedScene)

func _ready() -> void:
	area_2d_spawner.spawn_next_chunk.connect(_spawn_next_tile)
	
func _spawn_next_tile():
	tile_next_y_position += tile_y_offset
	
	var new_grass_tile_scene = grass_tile.instantiate()
	new_grass_tile_scene.position += Vector2(0, tile_next_y_position)
	tile_holder.call_deferred("add_child", new_grass_tile_scene)
	new_chunk.emit(new_grass_tile_scene)
	
	var new_fence_tile_scene = fence_tile.instantiate()
	new_fence_tile_scene.position += Vector2(0, tile_next_y_position)
	fence_holder.call_deferred("add_child", new_fence_tile_scene)
	new_chunk.emit(new_fence_tile_scene)

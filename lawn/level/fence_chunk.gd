extends Area2D

@onready var fence_sprite_1: Sprite2D = $Fence_Sprite_1
@onready var fence_sprite_2: Sprite2D = $Fence_Sprite_2

func _ready() -> void:
	var random_int = randi_range(1,2)
	
	if (random_int % 2):
		fence_sprite_1.visible = false
	else:
		fence_sprite_2.visible = false

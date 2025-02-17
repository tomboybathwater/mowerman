extends Area2D

@onready var main_sprite_2d: Sprite2D = $MainSprite2D

#obstacle settings
@export var score_change := 0
@export var speed_change := 0 
@export var hit_sound : AudioStream

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area_that_entered: Area2D):
	
	if (area_that_entered.is_in_group("mower")):
		area_that_entered.on_collision_with_obstacle(score_change, speed_change)
		_destroy_obstacle(area_that_entered)

func _destroy_obstacle(area_that_entered):
	
	var rubble_emmitter_array: Array = [get_node("GPUParticle_Right"), get_node("GPUParticle_Left")]
	for rubble_emitter in rubble_emmitter_array:
		if (area_that_entered.get_node("BladeHook")):
			rubble_emitter.global_position = area_that_entered.get_node("BladeHook").global_position
		rubble_emitter.emitting = true
	
	#play SFX
	var sfx_node: AudioStreamPlayer2D = get_node("HitSoundPlayer")
	sfx_node.play()
	
	#animate the body going away
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(main_sprite_2d, "scale", Vector2(), 1.0)
	tween.finished.connect(func():
		queue_free()
	)

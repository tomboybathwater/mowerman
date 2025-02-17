extends Area2D

@onready var rich_text_label: RichTextLabel = $CanvasGroup/RichTextLabel

#movement
const MOWER_MAX_SPEED := 1000
const MOWER_MIN_SPEED := 50
var mower_speed := 200.0
var current_mower_speed : float
var speed_stage_amount := 20
var velocity := Vector2(0,0)

var hit_stop_state := false
var hit_stop_speed := 10

var mower_steering_strength := 0.5
var mower_steering_factor := 0.5

var forward_factor := -0.5
var full_forward := -1.0
var brake_forward := -0.4

#tire turning
var tire_inline_degree := 0
var tire_turn_degree := 15
var tire_well_steering_factor := 0.05

#tirespin
var tire_sprite_array : Array

#body shake
var body_shake_tween = Tween

#body parts
#--------------------------------
#markers
var tire_well_left: Marker2D
var tire_well_right: Marker2D
#sprites
var mower_body_sprite: Sprite2D
var wheel_sprite_fl: Sprite2D
var wheel_sprite_fr: Sprite2D
var wheel_sprite_bl: Sprite2D
var wheel_sprite_br: Sprite2D
var steering_wheel_sprite: Sprite2D

signal shake_mower

func _ready() -> void:
	tire_well_left = $marker_body/marker_fl
	tire_well_right = $marker_body/marker_fr
	steering_wheel_sprite = $marker_body/sprite_steer
	mower_body_sprite = $marker_body/sprite_body
	wheel_sprite_fl = $marker_body/marker_fl/sprite_fl_tire
	wheel_sprite_fr = $marker_body/marker_fr/sprite_fr_tire
	wheel_sprite_bl = $marker_body/sprite_bl_tire
	wheel_sprite_br = $marker_body/sprite_br_tire
	
	tire_sprite_array = [
		load("res://assets/mower/tire.png")
		,load("res://assets/mower/tire2.png")
	]

func _process(delta: float) -> void:
	
	var direction := Vector2(0,0)
	direction.x = clampf(Input.get_axis("move_left", "move_right"), -mower_steering_strength, mower_steering_strength)
	direction.y = forward_factor
	
	if (direction.length() > 1.0):
		direction = direction.normalized()
	
	if (hit_stop_state):
		current_mower_speed = hit_stop_speed
	else:
		current_mower_speed = mower_speed
		
	var desired_velocity := current_mower_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * mower_steering_factor * delta
	position += velocity * delta
	
	if velocity.length() > 0.0:
		rotation = velocity.angle()
	
	_handle_tire_wells(direction)
	
	rich_text_label.text = "Speed: " + str(current_mower_speed)
	
func _handle_tire_wells(direction: Vector2):
	var target_rotation = 0.0

	if direction.x > 0:
		target_rotation = tire_turn_degree
	elif direction.x < 0:
		target_rotation = -tire_turn_degree
	else:
		target_rotation = tire_inline_degree

	tire_well_left.rotation_degrees = lerpf(tire_well_left.rotation_degrees, target_rotation, tire_well_steering_factor)
	tire_well_right.rotation_degrees = lerpf(tire_well_right.rotation_degrees, target_rotation, tire_well_steering_factor)
	steering_wheel_sprite.rotation_degrees = lerpf(steering_wheel_sprite.rotation_degrees, target_rotation, tire_well_steering_factor)

func _on_tire_spin_timer_timeout() -> void:
	var wheel_array : Array = [wheel_sprite_fl,wheel_sprite_fr,wheel_sprite_bl,wheel_sprite_br]
	for wheel in wheel_array:
		if wheel.texture == tire_sprite_array[0]:
			wheel.texture = tire_sprite_array[1]
		else:
			wheel.texture = tire_sprite_array[0]

func on_collision_with_obstacle(score_change: int, speed_change: int):
	
	if (speed_change != 0):
		#mower_speed += speed_stage_amount * speed_change
		if (speed_change < 0 ):
			shake_mower.emit()
			# hit rock speed
			hit_stop_state = true
			await get_tree().create_timer(0.5).timeout
			hit_stop_state = false

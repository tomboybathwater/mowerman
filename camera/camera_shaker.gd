extends Node2D

# The starting range of possible offsets using random values
@export var RANDOM_SHAKE_STRENGTH: float = 15.0
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 5.0

@onready var camera = $"../MowerCam"
@onready var rand = RandomNumberGenerator.new()

# Reference to the mower scene
@export var mower : Node = null

var shake_strength: float = 0.0

func _ready() -> void:
	mower = $"../LawnMower"
	rand.randomize()
	
	# Connect the mower's 'hit_rock' signal to apply_shake, if the mower is set
	if mower:
		mower.shake_mower.connect(_on_mower_hit_rock)

func _process(delta: float) -> void:
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)

	# Shake by adjusting camera.offset so we can move the camera around the level via its position
	camera.offset = get_random_offset()

func apply_shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)

func _on_mower_hit_rock():
	apply_shake()

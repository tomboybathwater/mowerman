extends Camera2D

var initial_x_position: float = 0
var lawn_mower: Node = null
var camera_hook: Node2D = null

# Smoothing variables
var smoothing_speed: float = 5.0
var target_position: Vector2

func _ready():
	# Store the Camera2D's initial X position
	initial_x_position = global_position.x

	# Set initial target position to current position
	target_position = global_position

	# Find the LawnMower node
	lawn_mower = get_node_or_null("../LawnMower")

	if lawn_mower:
		# Find the CameraHook node within the LawnMower
		camera_hook = lawn_mower.get_node_or_null("CameraHook")

	if not camera_hook:
		push_error("CameraHook not found under LawnMower")

func _process(delta: float):
	if camera_hook:
		# Update the target position based on the CameraHook's Y position
		target_position.y = camera_hook.global_position.y

		# Keep the X position fixed to the initial position
		target_position.x = initial_x_position

		# Smoothly interpolate the camera's position towards the target position
		global_position = global_position.lerp(target_position, smoothing_speed * delta)

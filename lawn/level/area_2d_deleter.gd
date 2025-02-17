extends Area2D

var camera: Camera2D
var y_offset: float

func _ready() -> void:
	
	area_entered.connect(_on_area_entered)
	
	# Retrieve the current Camera2D from the viewport
	camera = get_viewport().get_camera_2d()
	if camera:
		# Calculate the initial vertical offset between the Area2D and the Camera2D
		y_offset = global_position.y - camera.global_position.y
	else:
		push_warning("No active Camera2D found!")

func _process(delta: float) -> void:
	if camera:
		# Update only the Y coordinate to follow the Camera2D while maintaining the initial offset.
		global_position.y = camera.global_position.y + y_offset
		
func _on_area_entered(area_that_entered: Area2D):
	area_that_entered.get_parent().queue_free()
	print("Area BELETED!")

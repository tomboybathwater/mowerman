extends Sprite2D

# Exposed offset for the shadow, adjustable in the editor
@export var shadow_offset: Vector2 = Vector2(5, 5)

# Semi-transparent black color for the shadow
const SHADOW_COLOR = Color("#00000066")

func _ready() -> void:
	# Get the parent as a Sprite2D
	var parent_sprite = get_parent() as Sprite2D
	if parent_sprite:
		# Copy the parent's texture
		texture = parent_sprite.texture
		# Copy the parent's region if enabled
		region_enabled = parent_sprite.region_enabled
		region_rect = parent_sprite.region_rect if region_enabled else region_rect
		
		# Set self modulate to shadow color
		self_modulate = SHADOW_COLOR
		
		# Set order to be 1 below the parent
		z_index = parent_sprite.z_index - 1
		
		_build_canvas_material()

func _process(delta: float) -> void:
	# Get the parent's global position
	var parent_global_position = get_parent().global_position
	
	# Update the sprite's position with the adjustable shadow offset
	global_position = parent_global_position + shadow_offset
	
func _build_canvas_material():
	# Create a new CanvasItemMaterial
	var mower_material = CanvasItemMaterial.new()
	mower_material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX  # Ensures proper transparency handling
	#material.premultiplied_alpha = false                     # Disable premultiplied alpha
	self.material = mower_material

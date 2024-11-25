extends Node3D

var radius = 3  # Circle radius
var angle = 0.0   # Current angle
var speed = 1.5   # Rotation speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	 # Increment angle based on speed and delta time
	angle += speed * delta
	
	# Calculate new position using trigonometry
	var x_pos = radius * cos(angle)
	var y_pos = radius * sin(angle)
	
	# Update position
	position = Vector3(x_pos, 4, y_pos)

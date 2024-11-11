extends SpotLight3D

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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "NinjaCollider":
		SignalBus.emit_signal("seen_by", 1)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "NinjaCollider":
		SignalBus.emit_signal("seen_by", -1)

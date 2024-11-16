extends MeshInstance3D

var speed = 50.0
var start_position = Vector3(0, 0, -125)
var target_position = Vector3(0, 0, 125)

func _ready():
	global_transform.origin = start_position
	print("Ground created: ", start_position)

func _process(delta):
	translate(Vector3(0, 0, speed * delta))

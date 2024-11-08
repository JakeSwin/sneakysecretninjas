extends Node3D

var green_ground = preload("res://Green Ground.tscn")
var white_ground = preload("res://White Ground.tscn")
var blue_ground = preload("res://Blue Ground.tscn")
var bush = preload("res://Bush.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	# Start the timer to spawn planes
	$Timer.wait_time = 1
	$Timer.start()
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout():
	# Instance a new plane and add it to the scene
	var new_ground
	var pick_ground = rng.randi_range(0, 2)
	
	match pick_ground:
		0:
			new_ground = green_ground.instantiate()
		1:
			new_ground = white_ground.instantiate()
		2:
			new_ground = blue_ground.instantiate()
	add_child(new_ground)
	spawn_bushes(new_ground)

func spawn_bushes(ground):
	var bush_count = 100  
	var plane_width = 5  
	var plane_length = 50
	
	for i in range(bush_count):
		var new_bush = bush.instantiate()
		print("New bush instance: ", new_bush)
		
		var random_x = randf_range(-plane_width / 2, plane_width / 2)
		var random_z = randf_range(-plane_length / 2, plane_length / 2)
		var new_position = Vector3(random_x, 0.5, random_z)
		
		new_bush.set_position(new_position)
		
		ground.add_child(new_bush)

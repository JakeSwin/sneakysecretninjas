extends Node3D

var time = 0
var time_direction = 1
var move_duration = 2
var point1 = Vector3(0, 0, 0)
var point2 = Vector3(0, 0, -5)

func _process(delta):
	if time > move_duration or time < 0:
		time_direction *= -1
	
	time += delta * time_direction
	var t = time / move_duration
	position = lerp(point1, point2, t)

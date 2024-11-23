extends Label

var elapsed_time = 0.0

func _ready():
	$Timer.start()

func _on_timer_timeout() -> void:
	$Timer.start()
	elapsed_time += 1
	timering()

func timering():
	var min = int(elapsed_time) / 60
	var sec = int(elapsed_time) % 60
	$".".text = "%02d:%02d" % [min, sec]

extends Label

var elapsed_time = 0.0
var save_file = FileAccess.open("user://leaderboard.json", FileAccess.READ)

func _ready():
	#$Timer.start()
	$".".visible = false
	SignalBus.connect("caught", urcaught)
	SignalBus.connect("swapping", start)
	timering()

func _on_timer_timeout() -> void:
	$Timer.start()
	elapsed_time += 1
	timering()

func timering():
	var min = int(elapsed_time) / 60
	var sec = int(elapsed_time) % 60
	text = "%02d:%02d" % [min, sec]

func urcaught(player_object):
	$Timer.stop()
	$"../SaverLoader".save_score()
	print("Score Saved")
	await get_tree().create_timer(2.0).timeout
	
func start():
	await get_tree().create_timer(2).timeout
	$Timer.start()
	$".".visible = true
	$"..".MOUSE_FILTER_IGNORE

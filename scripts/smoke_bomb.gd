extends Button

var cooldown = false

func kaboom():
	if cooldown == false:
		$Label/Timer.start() # Cooldown timer
		cooldown = true
		$Label/Timer2.start() # Timer that updates the visible timer
		var time_left = (snapped($Label/Timer.time_left, 0.1))
		$Label.text = str(time_left)
		$Label.visible = true
		$ProgressBar.visible = true
		$ProgressBar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$ProgressBar.max_value = time_left
	else:
		print("Smoke Bomb is on cooldown")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("smokebomb"):
		kaboom()
		
func _on_pressed():
	kaboom()

func _on_timer_timeout():
	print("Smoke Bomb can now be used")
	$Label.visible = false
	cooldown = false
	$ProgressBar.visible = false
	
func _on_timer_2_timeout():
	$Label.text = str(snapped($Label/Timer.time_left, 0.1))
	$ProgressBar.value = (snapped($Label/Timer.time_left, 0.1))
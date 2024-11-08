extends Button

var cooldown = false


func _on_pressed():
	if cooldown == false:
		$Label/Timer.start()
		cooldown = true
		$Label/Timer2.start()
		$Label.text = str(snapped($Label/Timer.time_left, 0.1))
		$Label.visible = true
	else:
		print("Shuriken is on cooldown")
	
func _on_timer_timeout():
	print("Shuriken can now be used")
	$Label.visible = false
	cooldown = false

func _on_timer_2_timeout():
	$Label.text = str(snapped($Label/Timer.time_left, 0.1))

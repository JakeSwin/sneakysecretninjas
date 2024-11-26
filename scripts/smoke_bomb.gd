extends Button

var cooldown = false
var particle: PackedScene
var particles_instance: Node
var ninja: Node

func _ready() -> void:
	particle = load("res://scenes/smoke_effect.tscn")
	particles_instance = particle.instantiate()
	add_child(particles_instance)
	particles_instance.emitting = false
	ninja = get_tree().get_nodes_in_group("ninja")[0]
	
	
func kaboom():
	if cooldown == false:
		$Label/Timer.start() # Cooldown timer
		cooldown = true
		$Label/Timer2.start() # Timer that updates the visible timer
		var time_left = (snapped($Label/Timer.time_left, 0.1))
		$Label/Timer3.start()
		$Label.text = str(time_left)
		$Label.visible = true
		$ProgressBar.visible = true
		$ProgressBar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$ProgressBar.max_value = time_left
		Global.smoked = true
		particles_instance.global_position = ninja.global_position
		particles_instance.emitting = true
		await get_tree().create_timer(3.0).timeout
		particles_instance.emitting = false
	else:
		print("Smoke Bomb is on cooldown")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("smokebomb"):
		kaboom()
		
func _on_pressed():
	kaboom()

func _on_timer_timeout(): #This controls the cooldown
	print("Smoke Bomb can now be used")
	$Label.visible = false
	cooldown = false
	$ProgressBar.visible = false
	
func _on_timer_2_timeout(): #This controls the text label which displays the cooldown
	$Label.text = str(snapped($Label/Timer.time_left, 0.1))
	$ProgressBar.value = (snapped($Label/Timer.time_left, 0.1))
	

func _on_timer_3_timeout(): #This controls the duration of the smoke bomb
	Global.smoked = false

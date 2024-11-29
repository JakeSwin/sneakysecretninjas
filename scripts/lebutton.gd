extends Button



func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_d.tscn")
	#await get_tree().create_timer(2).timeout
	#SignalBus.emit_signal("swapping")

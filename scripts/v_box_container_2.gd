extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("caught", lecatched)
	$Label.visible = false
	$Button.visible = false
	$Button2.visible = false

func lecatched(player_object):
	$Label.visible = true
	$Button.visible = true
	$Button2.visible = true
	$"../../VBoxContainer/HBoxContainer/Shuriken/Label/Timer".stop()
	$"../../VBoxContainer/HBoxContainer/Shuriken/Label/Timer2".stop()
	$"../../VBoxContainer/HBoxContainer/SmokeBomb/Label/Timer".stop()
	$"../../VBoxContainer/HBoxContainer/SmokeBomb/Label/Timer2".stop()
	$"../../VBoxContainer/HBoxContainer/SmokeBomb/Label/Timer3".stop()
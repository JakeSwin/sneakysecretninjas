extends Button

func _ready() -> void:
	SignalBus.connect("gobackiwanttobemonke", monkey)

func _on_pressed() -> void:
	$".".visible = false
	$"../Button2".visible = false
	SignalBus.emit_signal("swapping")
	
func _on_button_2_pressed() -> void:
	$".".visible = false
	$"../Button2".visible = false
	SignalBus.emit_signal("leaderswap")

func monkey():
	print("Signal Recieved")
	$".".visible = true
	$"../Button2".visible = true

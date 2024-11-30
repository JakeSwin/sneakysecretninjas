extends Node

func _ready():
	Global.leaderboard = ["00.00","00.00","00.00","00.00","00.00","00.00","00.00","00.00","00.00","00.00"]
	$"../SaverLoader".load_score()
	$".".text = Global.leaderboard[0]
	$"../Label2".text = Global.leaderboard[1]
	$"../Label3".text = Global.leaderboard[2]
	$"../Label4".text = Global.leaderboard[3]
	$"../Label5".text = Global.leaderboard[4]
	$"../Label6".text = Global.leaderboard[5]
	$"../Label7".text = Global.leaderboard[6]
	$"../Label8".text = Global.leaderboard[7]
	$"../Label9".text = Global.leaderboard[8]
	$"../Label10".text = Global.leaderboard[9]
	$"../TopText".visible = false
	$".".visible = false
	$"../Label2".visible = false
	$"../Label3".visible = false
	$"../Label4".visible = false
	$"../Label5".visible = false
	$"../Label6".visible = false
	$"../Label7".visible = false
	$"../Label8".visible = false
	$"../Label9".visible = false
	$"../Label10".visible = false
	
	SignalBus.connect("leaderswap", vanish)
	SignalBus.connect("gobackiwanttobemonke", unvanish)

func vanish():
	$"../TopText".visible = true
	$".".visible = true
	$"../Label2".visible = true
	$"../Label3".visible = true
	$"../Label4".visible = true
	$"../Label5".visible = true
	$"../Label6".visible = true
	$"../Label7".visible = true
	$"../Label8".visible = true
	$"../Label9".visible = true
	$"../Label10".visible = true
	$"../Button".visible = true


	

func unvanish():
	$"../TopText".visible = false
	$".".visible = false
	$"../Label2".visible = false
	$"../Label3".visible = false
	$"../Label4".visible = false
	$"../Label5".visible = false
	$"../Label6".visible = false
	$"../Label7".visible = false
	$"../Label8".visible = false
	$"../Label9".visible = false
	$"../Label10".visible = false
	$"../Button".visible = false


func _on_button_pressed() -> void:
	SignalBus.emit_signal("gobackiwanttobemonke")
	print("Signal Emitted")

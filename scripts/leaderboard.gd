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

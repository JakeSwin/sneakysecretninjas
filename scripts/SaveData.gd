class_name SaverLoader
extends Node
@onready var label: Label = $"../Label"
var oldscore
var newscore

func _ready():
	Global.leaderboard = [00.00,00.00,00.00,00.00,00.00,00.00,00.00,00.00,00.00,00.00]
	load_score()

func save_score():
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var saved_data = {}
	Global.leaderboard.append(label.text)
	Global.leaderboard.sort()
	Global.leaderboard.reverse()
	
	#saved_data["LatestScore"] = Global.leaderboard[-1]
	saved_data["TopScore"] = Global.leaderboard[0]
	saved_data["Second"] = Global.leaderboard[1]
	saved_data["Third"] = Global.leaderboard[2]
	saved_data["Fourth"] = Global.leaderboard[3]
	saved_data["Fifth"] = Global.leaderboard[4]
	saved_data["Sixth"] = Global.leaderboard[5]
	saved_data["Seventh"] = Global.leaderboard[6]
	saved_data["Eighth"] = Global.leaderboard[7]
	saved_data["Ninth"] = Global.leaderboard[8]
	saved_data["Tenth"] = Global.leaderboard[9]
	
	var json = JSON.stringify(saved_data)
	file.store_string(json)
	file.close()

func load_score():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if file == null:
		return
	var json = file.get_as_text()
	var saved_data = JSON.parse_string(json)
	
	#if len(Global.leaderboard) < 10:
		#initialise_score()
		#save_score()
	#Global.leaderboard.append(saved_data["LatestScore"])
	Global.leaderboard[0] = (saved_data["TopScore"])
	Global.leaderboard[1] = (saved_data["Second"])
	Global.leaderboard[2] = (saved_data["Third"])
	Global.leaderboard[3] = (saved_data["Fourth"])
	Global.leaderboard[4] = (saved_data["Fifth"])
	Global.leaderboard[5] = (saved_data["Sixth"])
	Global.leaderboard[6] = (saved_data["Seventh"])
	Global.leaderboard[7] = (saved_data["Eighth"])
	Global.leaderboard[8] = (saved_data["Ninth"])
	Global.leaderboard[9] = (saved_data["Tenth"])
	Global.leaderboard.sort()
	Global.leaderboard.reverse()
	file.close()

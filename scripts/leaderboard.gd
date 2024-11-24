extends Node

#var Score = Global.leaderboard  # Reference the global leaderboard
#var save_file = null
func _ready():
	$".".text = str(Global.leaderboard)

#func _ready():
	#create_save()
	#load_game()
	#SignalBus.connect("caught", save)
	#
#func save(player_object):
	#save_game()
#
## Save the leaderboard to a JSON file
#func save_game():
	#var save_data = {
		#"Score": Global.leaderboard  # Save the Score (leaderboard)
	#}
	#var json_string = JSON.stringify(save_data, "\t")  # Convert data to JSON format
	#var save_file = FileAccess.open("user://leaderboard.json", FileAccess.WRITE)
	#if save_file:
		#save_file.store_string(json_string)  # Save the JSON string to a file
		#print("Score saved successfully!")
	#else:
		#print("Failed to save the Score!")
#
## Load the leaderboard from a JSON file
#func load_game():
	#if not FileAccess.file_exists("user://leaderboard.json"):
		#print("No save file found!")
		#save_game()
		#return
#
	#var save_file = FileAccess.open("user://leaderboard.json", FileAccess.READ)
	#if save_file:
		#var json_string = save_file.get_as_text()  # Read the file as text
		#if json_string == "":
			#print("Save file is empty. Creating default data.")
			#save_game()  # Recreate the save file with default data
			#return
			#
		#var json = JSON.parse_string(json_string)  # Parse the JSON string
		#var save_data = json.result
#
		#if save_data is Dictionary:
			#Score = save_data.get("Score", [])  # Load the Score (default to empty array)
			#Global.leaderboard = Score  # Update the Global leaderboard
			#print("Score loaded successfully!")
		#else:
			#print("Loaded data is not a valid dictionary!")
		#Score = save_data.get("Score", [])  # Load the Score (default to empty array)
		#Global.leaderboard = Score  # Update the Global leaderboard
		#print("Score loaded successfully!")
	#else:
		#print("Failed to open save file!")

#func create_save():
	#save_file = FileAccess.open("user://leaderboard.json", FileAccess.WRITE)

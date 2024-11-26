extends Node
var smoked = false

var leaderboard = []

#func save(content):
	#var file = FileAccess.open(path, FileAccess.WRITE)
	#file.store_string(json.stringify(content))
	#file.close()
	#file= null
#
#func read_save():
	#var file = FileAccess.open(path, FileAccess.READ)
	#var content = json.parse_string(file.get_as_text())
	#return content

#func create_new_save():
	#var file = FileAccess.open("res://scripts/defualt_save.json", FileAccess.READ)
	#var content = json.parse_string(file.get_as_text())
	#leaderboard = content
	#save(content)
	#
	
#func _ready():
	

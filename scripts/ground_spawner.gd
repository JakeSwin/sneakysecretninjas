extends Node3D
var rng = RandomNumberGenerator.new()

#FastNoiseLite
var cover_noise: FastNoiseLite
var decoration_1: FastNoiseLite
var decoration_2: FastNoiseLite
var decoration_3: FastNoiseLite
var tree_noise: FastNoiseLite
var mushroom_map: PackedFloat64Array
var height_map: PackedFloat64Array
var max_noise_range = 1000000
var accumulated_z_distance = 0.0
#FastNoiseLite

#materials
var materials = [
	preload("res://Synty_assets/Synty_assets_textures/PolygonNature_01.png"), #spring
	preload("res://Synty_assets/Synty_assets_textures/PolygonNature_02.png"), #autumn
	preload("res://Synty_assets/Synty_assets_textures/PolygonNature_03.png"),
	preload("res://Synty_assets/Synty_assets_textures/PolygonNature_04.png")] #summer
const full_seasons = ["spring", "summer", "autumn"]
const semi_seasons = ["springsummer", "springautumn", "summerautumn"]
var current_season = ""
var season_streak = 0
#materials

#tile
var forest_tile = preload("res://scenes/forest_tile.tscn")
@export var speed: float = 5
var spawn_interval: float = 1
var time_since_last_spawn: float = 0.0
var tile_width = 16 
var tile_length = 50
var cell_size = 0.5
var starting_tile_amount = 11
var tiles: Array = []
var last_tile_position_z = -50 #This is so we can se a starting one at 0
var occupied_cells = {}
var z_offset = 0
var delete_threshold = 50
#tile

#Cover
var cover = [
	preload("res://scenes/bush_1.tscn"),
	preload("res://scenes/bush_2.tscn")]
var cover_different_season_colour_threshold = 0.65
#Cover

#decorations
var mushrooms = [
	preload("res://Synty_assets/mushrooms_1.tscn"),
	preload("res://Synty_assets/mushrooms_2.tscn"),
	preload("res://Synty_assets/twig_1.tscn")]
var rocks = [
	preload("res://Synty_assets/rock_1.tscn"),
	preload("res://Synty_assets/rock_2.tscn"),
	preload("res://Synty_assets/rock_3.tscn"),
	preload("res://Synty_assets/rock_4.tscn")]
var flowers = [
	preload("res://Synty_assets/flower_1.tscn"),
	preload("res://Synty_assets/flower_2.tscn"),
	preload("res://Synty_assets/flower_3.tscn"),
	preload("res://Synty_assets/flower_4.tscn"),
	preload("res://Synty_assets/flower_5.tscn")]
#decorations

#tree
var wiggle_room = 0.3
var small_trees = [
	preload("res://Synty_assets/tree_1.tscn"),
	preload("res://Synty_assets/tree_2.tscn"),
	preload("res://Synty_assets/tree_3.tscn")]
var big_trees = [
	preload("res://Synty_assets/big_tree_1.tscn")]
#tree

#testing
@export var spotlight_scene: PackedScene
#testing

func _ready():
	#Prepares the materials
	var material1 = StandardMaterial3D.new()
	material1.albedo_texture = load("res://Synty_assets/Synty_assets_textures/PolygonNature_01.png")
	var material2 = StandardMaterial3D.new()
	material2.albedo_texture = load("res://Synty_assets/Synty_assets_textures/PolygonNature_02.png")
	var material3 = StandardMaterial3D.new()
	material3.albedo_texture = load("res://Synty_assets/Synty_assets_textures/PolygonNature_03.png")
	var material4 = StandardMaterial3D.new()
	material4.albedo_texture = load("res://Synty_assets/Synty_assets_textures/PolygonNature_04.png")
	materials = [material1, material2, material3, material4]
	
	#Creates random noises, spawn intervals, tils and sets starting season
	new_noise_seed()
	calculate_spawn_interval()
	current_season = full_seasons[rng.randi_range(0, full_seasons.size() - 1)]
	for i in range(starting_tile_amount):
		spawn_tile()

func new_noise_seed():
	cover_noise = FastNoiseLite.new()
	cover_noise.seed = rng.randi()
	cover_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	cover_noise.frequency = 0.6
	
	decoration_1 = FastNoiseLite.new()
	decoration_1.seed = rng.randi()
	decoration_1.noise_type = FastNoiseLite.TYPE_PERLIN
	decoration_1.frequency = 0.5
	
	decoration_2 = FastNoiseLite.new()
	decoration_2.seed = rng.randi()
	decoration_2.noise_type = FastNoiseLite.TYPE_CELLULAR
	decoration_2.frequency = 0.3
	
	decoration_3 = FastNoiseLite.new()
	decoration_3.seed = rng.randi()
	decoration_3.noise_type = FastNoiseLite.TYPE_CELLULAR
	decoration_3.frequency = 0.4
	
	tree_noise = FastNoiseLite.new()
	tree_noise.seed = rng.randi()
	tree_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	tree_noise.frequency = 10

#Updates each tile's position using an array, if they are out a set range, it is deleted and a new one is spawned
func _process(delta):
	for i in range(tiles.size()):
		var tile = tiles[i][0]
		
		if not tile.is_queued_for_deletion():
			tile.global_transform.origin.z += speed * delta
			
			if tile.global_transform.origin.z > delete_threshold:
				tiles.remove_at(i)
				await delay(1)
				tile.queue_free()
				await delay(1)
				spawn_tile()
				await delay(1)
				break

func calculate_spawn_interval():
	spawn_interval = tile_length / speed
	#print("Spawn interval set to: ", spawn_interval)
	
func spawn_tile():
	var next_tile = forest_tile.instantiate()
	var new_season = determine_next_season()
	add_child(next_tile)
	
	if tiles.size() > 0:
		var last_tile = tiles[tiles.size() - 1][0]
		next_tile.global_transform.origin.z = last_tile.global_transform.origin.z - tile_length
	else:
		next_tile.global_transform.origin.z = last_tile_position_z
		
	tiles.append([next_tile, new_season])
	print("Tile spawned with season: ", new_season)
	
	cover_grid(next_tile)
	#await delay(0.001)
	spawn_decorations(next_tile, mushrooms, decoration_1, 0.75, 0.45, 0.3)
	#await delay(0.001)
	spawn_decorations(next_tile, rocks, decoration_2, 0.75, -0.26, 0.0)
	#await delay(0.001)
	spawn_decorations(next_tile, flowers, decoration_3, 0.25, -0.3, 0.3)
	#await delay(0.001)
	spawn_trees(next_tile, small_trees, tree_noise, 3, -0.6, 30, new_season)
	#wait delay(0.001)
	check_new_seed()

func delay(seconds):
	await get_tree().create_timer(seconds).timeout

#Decides the next season, stays in a season for a while, can swap season only to a connected one
func determine_next_season() -> String:
	if season_streak >= 4:
		season_streak = 0
		
		if current_season in full_seasons:
			var options = [current_season]
			for s in semi_seasons:
				if current_season in s:
					options.append(s)
			current_season = options[rng.randi_range(0, options.size() - 1)]
		elif current_season in semi_seasons:
			var options = full_seasons + semi_seasons
			current_season = options[rng.randi_range(0, options.size() - 1)]
	else:
		season_streak += 1
	return current_season

func cover_grid(tile):
	var cols = int(tile_width / cell_size)
	var rows = int(tile_length / cell_size)
	var consecutive_empty_rows = 0
	
	for row in range(rows):
		var has_cover = false
		if row == 0 or row == rows - 1: #Skips first and last row to avoid cover spawning on top of each other
			continue 
		for col in range(cols):
			var x = (col * cell_size) - (tile_width / 2)
			var z = (row * cell_size) - (tile_length / 2)
			
			var noise_value = cover_noise.get_noise_2d(fposmod(x, float(max_noise_range)), fposmod(z + z_offset, float(max_noise_range)))
			if noise_value > 0.4 and can_place_cover(x, z): #Increase/decrease the float to decrease/increase the amount of cover
				spawn_cover(tile, Vector3(x, 0, z))
				has_cover = true
			#if noise_value > 0.45:
				#spawn_spotlight(tile, Vector3(x, 0, z))
		#if initial == false:
			#await get_tree().create_timer(0.001).timeout
			
		if has_cover:
			consecutive_empty_rows = 0
		else:
			consecutive_empty_rows +=1
			
		if consecutive_empty_rows > 10: #Increase/decrease this value to decrease/increase the amount of backup cover
			backup_cover(tile, row, cols)
			consecutive_empty_rows = 0
			
	#debug_print_occupied_cells()
	occupied_cells.clear()
	
	z_offset = (z_offset + tile_length) % max_noise_range

#This is for debugging
func debug_print_occupied_cells():
	# Determine the range of cells to cover in the output
	var cols = int(tile_width / cell_size)
	var rows = int(tile_length / cell_size)
	
	# Create a 2D list to represent the map
	var map_grid = []
	for row in range(rows):
		map_grid.append([])  # Create an empty row
		for col in range(cols):
			map_grid[row].append(".")  # Use '.' to represent empty spaces initially
	
	# Mark occupied cells with an 'X'
	for cell in occupied_cells:
		# Assuming the 'cell' is a Vector2, where x is the x position and y is the z position
		var col_index = int((cell.x + (tile_width / 2)) / cell_size)
		var row_index = int((cell.y + (tile_length / 2)) / cell_size)
		
		# Ensure the indices are within bounds
		if row_index >= 0 and row_index < rows and col_index >= 0 and col_index < cols:
			map_grid[row_index][col_index] = "X"
	
	# Print the map in a grid format
	print("Occupied Cells Map:")
	for row in map_grid:
		print("".join(row))

func can_place_cover(x, z):
	for dx in range(-4, 5):
		for dz in range(-4, 5):
			var check_position = Vector2(x + dx * cell_size, z + dz * cell_size)
			if occupied_cells.has(check_position):
				return false
	return true

func mark_surrounding_cells(x, z):
	for dx in range(-4, 5):
		for dz in range(-4, 5):
			var occupied_position = Vector2(x + dx * cell_size, z + dz * cell_size)
			occupied_cells[occupied_position] = true

func spawn_cover(tile, position):
	var material_choices = get_season_materials(current_season)
	var chance = rng.randf()
	var new_cover = cover[rng.randi_range(0, cover.size() - 1)].instantiate()
	new_cover.position = position
	new_cover.rotation.y = deg_to_rad(rng.randi_range(0, 360))
	new_cover.scale *= randf_range(0.9, 1.1)
	tile.add_child(new_cover)
	mark_surrounding_cells(position.x, position.z)
	
	var cover_mesh = new_cover.get_child(0)
	#changes bush colour based on current season
	if current_season in full_seasons:
		cover_mesh.material_override = materials[material_choices[0]]
	elif current_season in semi_seasons:
		if chance <= cover_different_season_colour_threshold:
			cover_mesh.material_override = materials[material_choices[0]]
		else:
			cover_mesh.material_override = materials[material_choices[1]]

#Exists incase of big gaps in the noisemap
func backup_cover(tile, row, cols):
	var random_col = rng.randi_range(0, cols - 1)
	var x = (random_col * cell_size) - (tile_width / 2)
	var z = (row * cell_size) - (tile_length / 2)
	
	if can_place_cover(x, z):
		spawn_cover(tile, Vector3(x, 0, z))

func spawn_spotlight(tile, position):
	if spotlight_scene == null:
		print("Spotlight scene is not set")
		return
	
	var new_spotlight = spotlight_scene.instantiate()
	new_spotlight.position = position
	new_spotlight.scale *= randf_range(0.9, 1.1)
	
	if tile == null or not is_instance_valid(tile):
		new_spotlight.queue_free()
		return
	tile.add_child(new_spotlight) # Add the spotlight to the tile

func spawn_decorations(tile, decoration_scene: Array, noise_map, cell_size, noise_threshold, position_y):
	var material_choices = get_season_materials(current_season)
	var chance = rng.randf()
	var cols = int(tile_width / cell_size) 
	var rows = int(tile_length / cell_size) 
	
	for row in range(rows):
		for col in range(cols): 
			var x = (col * cell_size) - (tile_width / 2)
			var z = (row * cell_size) - (tile_length / 2)
			
			var noise_value = noise_map.get_noise_2d(fposmod(x, float(max_noise_range)), fposmod(z + z_offset, float(max_noise_range)))
			
			if noise_value > noise_threshold:  # Adjust threshold to control density -0.26 was used for mushrooms
				var new_decoration = decoration_scene[rng.randi_range(0, decoration_scene.size() - 1)].instantiate()
				new_decoration.position = Vector3(x, position_y, z)
				new_decoration.rotation.y = deg_to_rad(rng.randi_range(0, 360))
				new_decoration.scale *= randf_range(0.2, 0.4)
				var decoration_mesh = new_decoration.get_child(0)
				if current_season in full_seasons:
					decoration_mesh.material_override = materials[material_choices[0]]
				elif current_season in semi_seasons:
					if chance <= cover_different_season_colour_threshold:
						decoration_mesh.material_override = materials[material_choices[0]]
					else:
						decoration_mesh.material_override = materials[material_choices[1]]
				
				
				tile.add_child(new_decoration)

func spawn_trees(tile, tree_scene, noise_map, cell_size, noise_threshold, extra_width, new_season: String):
	var total_width = tile_width + 2 * extra_width
	var lane_half_width = tile_width / 4
	var lane_buffer = lane_half_width + 1.5 * cell_size #Doesn't place trees within N cell spaces each side next to the lane
	var material_choices = get_season_materials(new_season)
	var adjusted_noise_threshold = noise_threshold
	
	#Changes the amount of coloured accent trees based on duration in a season
	match season_streak:
		1:	adjusted_noise_threshold *= 0.8
		2:	adjusted_noise_threshold *= 0.6
		3:	adjusted_noise_threshold *= 0.4
		4:	adjusted_noise_threshold *= 0.2
	
	#Iterates through every grid value
	for row in range(int(tile_length / cell_size) + 1):
		for col in range(int(total_width / cell_size) + 1):
			var x = (col * cell_size) - (total_width / 2)
			var z = (row * cell_size) - (tile_length / 2)
			
			#Lets the trees spawn offset each time to make them less gridlike
			x += rng.randf_range(-wiggle_room, wiggle_room)
			z += rng.randf_range(-wiggle_room, wiggle_room)
			
			#Makes sure the trees are not in the path of the ninja
			if abs(x) <= lane_buffer and abs(z) <= (tile_length / 2):
				continue
			if abs(x) <= lane_half_width and abs(z) <= (tile_length / 4):
				continue
			if abs(x) > (total_width / 2) or abs(z) > (tile_length / 2):
				continue
				
			var noise_value = noise_map.get_noise_2d(fposmod(x, float(max_noise_range)), fposmod(z + z_offset, float(max_noise_range)))
			
			#Selects the tree type based on place on tile
			var tree_type = null
			if col <= 1 or col >= int(total_width / cell_size) - 1:
				tree_type = big_trees[rng.randi_range(0, big_trees.size() - 1)]
			else:
				tree_type = small_trees[rng.randi_range(0, small_trees.size() - 1)]
				
			#Instantiates tree
			var new_tree = tree_type.instantiate()
			new_tree.position = Vector3(x, 0, z)
			new_tree.rotation.y = deg_to_rad(rng.randi_range(0, 360))
			new_tree.scale *= randf_range(0.8, 1.3)
			
			#Changes tree material based on season and noisemap
			var tree_mesh = new_tree.get_child(0)
			tree_mesh.material_override = materials[material_choices[0]]
			if noise_value > adjusted_noise_threshold:
				tree_mesh.material_override = materials[material_choices[1]]
			tile.add_child(new_tree)

#Picks a material pattern based on the tile's season
func get_season_materials(new_season: String) -> Array:
	match new_season:
		"spring":	return [0, 0]
		"summer":	return [3, 3]
		"autumn":	return [1, 1]
		"springsummer":	return [0, 3]
		"springautumn":	return [0, 1]
		"summerautumn":	return [3, 1]
	return [0, 0] #failsafe

#Incase the game ever goes on too long it will not break or loop the noisemaps, it will spawn new ones
func check_new_seed():
	z_offset += tile_length
	accumulated_z_distance += tile_length
	if accumulated_z_distance >= max_noise_range:
		accumulated_z_distance = 0.0
		new_noise_seed()

extends Node3D

var rng = RandomNumberGenerator.new()

var height_noise: FastNoiseLite
var height_map: PackedFloat64Array

var green_tile = preload("res://scenes/green_tile.tscn")
var white_tile = preload("res://scenes/white_tile.tscn")
var blue_tile = preload("res://scenes/blue_tile.tscn")

var cover = preload("res://scenes/bush.tscn")
var backup_cover = preload("res://scenes/backup_bush.tscn")

var tile_width = 10
var tile_length = 50
var cell_size = 0.5

var occupied_cells = {}
var z_offset = 0
var max_noise_range = 1000000
var accumulated_z_distance = 0.0

func _ready():
	$Timer.wait_time = 1
	$Timer.start()
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
	height_noise = FastNoiseLite.new()
	new_noise_seed()

func new_noise_seed():
	height_noise.seed = rng.randi()
	height_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	height_noise.frequency = 0.6

func _on_Timer_timeout():
	var next_tile
	match rng.randi_range(0, 2):
		0:	next_tile = green_tile.instantiate()
		1:	next_tile = white_tile.instantiate()
		2:	next_tile = blue_tile.instantiate()
		
	add_child(next_tile)
	cover_grid(next_tile)
	check_new_seed()

func cover_grid(tile):
	var cols = int(tile_width / cell_size)
	var rows = int(tile_length / cell_size)
	var consecutive_empty_rows = 0
	
	for row in range(rows):
		var has_cover = false
		for col in range(cols):
			var x = (col * cell_size) - (tile_width / 2)
			var z = (row * cell_size) - (tile_length / 2)
			
			var noise_x = fposmod(x, float(max_noise_range))
			var noise_z = fposmod(z + z_offset, float(max_noise_range))
			var noise_value = height_noise.get_noise_2d(noise_x, noise_z)
			
			if noise_value > 0.4 and can_place_cover(x, z): #Increase/decrease the float to decrease/increase the amount of cover
				spawn_cover(tile, Vector3(x, 0.5, z))
				has_cover = true
				
		if has_cover:
			consecutive_empty_rows = 0
		else:
			consecutive_empty_rows +=1
			
		if consecutive_empty_rows > 10: #Increase/decrease this value to decrease/increase the amount of backup cover
			place_backup_cover(tile, row, cols)
			consecutive_empty_rows = 0
	
	occupied_cells.clear()
	z_offset = (z_offset + tile_length) % max_noise_range

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
	if can_place_cover(position.x, position.z):
		var new_cover = cover.instantiate()
		new_cover.position = position
		tile.add_child(new_cover)
		mark_surrounding_cells(position.x, position.z)

func place_backup_cover(tile, row, cols):
	var random_col = rng.randi_range(0, cols - 1)
	var x = (random_col * cell_size) - (tile_width / 2)
	var z = (row * cell_size) - (tile_length / 2)
	
	if can_place_cover(x, z):
		var new_backup_cover = backup_cover.instantiate()
		new_backup_cover.position = Vector3(x, 0.5, z)
		tile.add_child(new_backup_cover)
		mark_surrounding_cells(x, z)

func check_new_seed():
	z_offset += tile_length
	accumulated_z_distance += tile_length
	if accumulated_z_distance >= max_noise_range:
		accumulated_z_distance = 0.0
		new_noise_seed()
